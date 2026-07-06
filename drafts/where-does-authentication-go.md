---
title: Where Does Authentication Go?
description: A worked example for ports and adaptors - pulling authentication apart into the layer each piece belongs in, and keeping your tests able to see it.
published: false
date: 2026-07-02 11:36:45
tags:
  - PortsAndAdaptors
---

_**Dave Does Architecture** - a series:_

1. [In Defence of Architecture](/posts/2026/7/2/in-defence-of-architecture)
2. [The Parts of a Ports and Adaptors Application](/posts/2026/7/3/the-parts-of-a-ports-and-adaptors-application)
3. [Wiring Up a Ports and Adaptors Application](/posts/2026/7/3/wiring-up-a-ports-and-adaptors-application)
4. How Do You Test a Ports and Adaptors Application? _(coming soon)_
5. **Where Does Authentication Go?** - _you are here_

---

This is a follow-on from [In Defence of Architecture](/posts/2026/7/2/in-defence-of-architecture), and it leans hard on the vocabulary from it - ports, adaptors, use cases, out-ports, and the DDTs (domain-driven tests) that drive them. If none of those words mean much to you yet, start there; I'll wait.

That post made a promise I want to cash in: get the wiring right and the hard problems fall into obvious places. So let's take a problem everyone has to solve and nearly everyone puts in the wrong place: authentication.

The first move is to notice that "authentication" is really several different things, and they don't all live in the same layer. Pull them apart and each one falls into an obvious home.

This is almost like some sort of logical proof, so let's turn it into one:

### Premise: the identity itself is a domain value

The _result_ of authenticating is a small fact: "this call is being made by this user, with these claims". That's a domain type - a `UserId`, a `Principal`, call it what you like (I'll use `UserId`). It isn't a token and it isn't a header. It's a value, and like every other domain value it travels _inward_, as part of the command or query the use case receives.

### Therefore, turning a credential into that identity is adaptor work

Parsing the `Authorization` header, checking a JWT's signature, reading a session cookie - that's transport plumbing, and transport plumbing is what an in-adaptor is _for_. The HTTP adaptor already turns a request into a use-case call; working out _who_ is making the call is just part of that same translation. (Any signing keys it needs come from `Bootstrap`, like all configuration.)

### If verifying the credential means hitting something, that something must be an out-port

A session store, a users table, a call out to an identity provider - these are out-ports like any other, faked and contract-tested exactly as we've described. If your scheme is stateless - a JWT you can verify with a key alone - there's no out-port at all; it stays in the adaptor.

### Authorization - "is this user _allowed_ to do this?" - goes inside the use case

This is the one people get wrong, and it's the one this whole approach refuses to let you fudge. Whether a user may perform an action is a _business rule_. It is not a property of HTTP. It belongs below the in-port, in the application, next to the logic it protects.

Here's why that isn't just tidiness. Your DDTs drive the in-ports directly, with no HTTP in the way. If you put authorization up in the HTTP layer - route annotations, a middleware that checks a role - then the direct-driver tests _cannot see it_. Your single most important rules, the ones about who is allowed to do what, would be exercised only in the slow wrapped configuration, if you remembered to cover them at all. Push authorization below the in-port and the whole DDT suite tests it at every level, for free.

So the same decomposition, one more time:

| Concern | Lands in | Tested by |
|---|---|---|
| The `UserId` / identity type | domain | it's just an argument - pass whichever identity you like |
| Parsing and verifying the credential | in-adaptor | the wrapped DDTs, plus a fake transport for the 401 paths |
| Looking up a session / calling an IdP | out-port | an in-memory fake, guaranteed by a contract test |
| **The authorization decision** | **use case** | **every DDT, direct or wrapped** |

And look what it buys you at test time. Because the `UserId` is just an input to the use case, testing authorization needs no tokens, no HTTP, no fixtures: you drive the in-port directly with an admin, an anonymous user, the _wrong_ user, and assert on what happens. Fast, readable, and in the application's own language.

Which is the whole point, put another way: authentication is how the outside world proves who it is, at the edge; authorization is something your application does, in the middle, in its own words.

## When getting the identity needs a round-trip: identity is actually a different domain

There's a wrinkle in all that. I said the in-adaptor turns the credential into a `UserId` - which is fine when it can do that on its own - somehow. By magic. I'm waving my hands, do not pay attention to the man behind the green curtain.

But usually, in every system I've worked on, it can't. An opaque token has to be introspected; a session id has to be looked up; a cookie has to be exchanged with an identity provider. Now producing the identity needs _I/O_ - and I/O means an out-port, and adaptors have no business _consuming_ out-ports. That's the application's job. Oh no our beautiful wonderland has fallen apart what shall we do?

The way out is to notice that this, too, is just a use case. Authentication that needs a round-trip is _just an in-port like any other_:

- an `IdentifyUser` use case takes the raw credential - the token or session id - and returns a `UserId`, or fails;
- its implementation is a query handler that uses an out-port - a `TokenIntrospector`, an `IdentityProvider`, a `SessionStore`, or all three - to do the exchange;
- and (here's the science bit) the HTTP adaptor runs it as _middleware_: credential in, `IdentifyUser`, `UserId` out, and only _then_ the business use case, with that `UserId` in hand.

So the adaptor still isn't consuming an out-port. It's calling an in-port, exactly as it always does. The round-trip happens _behind_ that in-port, through an out-port, wired like everything else. Authentication just turns out to be another use case - the model recurses, which is usually a sign you've got the model right.

It's worth being precise about that middleware, because it isn't a special thing bolted on outside the architecture. The middleware _is_ the in-adaptor for the `IdentifyUser` use case - the same kind of thing as a route handler, turning HTTP into a use-case call. The only difference is how it's mounted: a route handler is bound to one path, and middleware wraps many. Same job, different fixing.

Which means a protected request runs through _two_ in-adaptors, (gulp!) but don't worry, that's exactly right. First the auth middleware adapts the request into `IdentifyUser` and comes back with a `UserId` (or, on failure, translates that into a 401 - how a rejection looks over HTTP is transport, not business). Then the route handler adapts the request into the business use case, folding in the `UserId` the middleware just established. Two adaptors, two use cases, one request.

If that "two use cases in one request" makes you itch - good instinct, wrong alarm. It is _not_ the thing we forbade earlier. The rule was that a use case must never _depend on_ another use case - never have one wired in as its own dependency, because that's what breeds hidden coupling and the urge to mock. This isn't that. These are two _independent_ in-port calls, and neither knows the other exists; the sequencing lives in the adaptor, which is precisely where edge-level orchestration belongs. Authenticate-then-act is a uniform policy at the door, not a business workflow. The adaptor is allowed to make more than one in-port call per request - that's its job. What it is not allowed to do is make a _decision_ that belongs inside.

You might reach instead for a shared application service - an `Authenticator` that the business use case calls to turn an `Identifier` into an `Identity`. Resist it. The moment the use case takes the raw `Identifier`, the token has crossed the boundary and undone the one thing that was doing all the work: now the token leaks inward, every use case has to _remember_ to authenticate (a hole waiting to happen, where middleware is secure by default), and every business test has to drag a valid credential along instead of just handing over the `UserId` it wants. Keep the resolution in front of the use case; pass the resolved identity in as data. (Shared application services still earn their place for logic that runs on an _already-resolved_ identity - working a `UserId`'s roles into effective permissions, say. That lives inside, so it can be shared inside. The token exchange crosses the boundary, so it can't.)

A couple of lines stay firm here. _Which_ routes get wrapped - public versus protected - is adaptor-layer wiring: a fact about how you mount things, not a business rule, so it's happy living at the edge. But whether the user is _allowed_ to do the thing is still authorization, and that stays down in the business use case. The middleware establishes _who_; the use case decides whether they _may_. The moment the middleware starts making that second call, your DDTs go blind to it again - and we've been here before.

And it stays testable all the way down. The exchange out-port is faked and contract-tested against the real provider, so your fast tests never touch the network but you still trust the real thing. The `IdentifyUser` use case is driven directly in a DDT - a good token gives the right `UserId`, a garbage one gives a clean failure, an expired one takes the expiry path - with no HTTP anywhere. And the business use case still never sees a raw token; it only ever receives a `UserId`. That boundary is exactly the thing that keeps authentication from leaking inwards.

And when testing all other use cases, well - if we're driving the application directly, we're just passing a `UserId` around, testing authorisation and seeing what our different users can do.

But if we're driving through the HTTP adaptor, things get a little more interesting. What you can do here is - quite obviously when you think about it - _fake the relevant out-ports_. So either stub out the `TokenIntrospector` or `SessionStore` or all three. Of course, you could just have a fake implementation of the authentication domain, with all the fun of registering a user etc. But this will lead to a lot of overhead for the test setup.

Two loose ends, quickly:

### Caching

_Caching_ the exchange, so you're not introspecting on every single request, lives inside the `TokenIntrospector` out-adaptor - it's an implementation detail of the out-port, invisible to everyone above. And _minting_ a token to hand back - a refresh flow, a fresh `Set-Cookie` - is just the mirror image: the use case returns a domain value ("a new session"), and the adaptor serialises _that_ into a header. Inbound exchange is a use case plus an out-port; outbound issuance is a use case returning a value that the adaptor writes out.

The one-liner survives the complication, only sharper: the raw token belongs to the edge, and only the `UserId` is allowed inside.

### A whole different domain

And here's another way to see the whole thing, which might be the cleanest of all: authentication is simply _another domain_ - identity and access, with its own language of tokens and sessions and claims - and we've chosen to deal with it _before_ our application's boundary. `IdentifyUser` and its middleware are the border crossing between that domain and ours. On the far side, the currency is tokens; on our side, it's `UserId`s; and the crossing is the one place the two are exchanged. Which is why the token never comes further in - it's foreign currency, a different domain, and we changed it at the border.

---
title: Wiring Up a Ports and Adaptors Application
description: Once you know the parts of a ports-and-adaptors application, you have to build them - in the right order, from the edges in. This is how, and where the wiring code belongs.
published: false
date: 2026-07-03 12:36:45
tags:
  - PortsAndAdaptors
---

# Wiring Up a Ports and Adaptors Application

This is a companion to [The Architecture Is the Easy Part](/posts/2026/7/2/the-architecture-is-the-easy-part), and it assumes the parts named there - the domain, the ports, the use cases, the adaptors. If those are unfamiliar, start there.

That post drew the design: the hexagon, the two edges, the names for each part. Here's the question it left open - how do you _build_ that design from nothing, every time the program starts?

When you start a program you create a pile of objects and then combine them in particular ways to get the effects you want, both the business logic and the way it talks to the outside world. This creating-and-combining is usually called _wiring up_, and that's what I'm going to call it too. 

Here's the thing the architecture diagram doesn't quite show. On paper the out-ports and the use cases sit at the same level of abstraction. In practice there's a dependency tree: the use cases depend on the out-ports (and on any application services we extract, which themselves depend on the out-ports). And that tree dictates the order you have to build things in.

And this is the bit where it all goes wrong.

I've seen a lot of lip-service paid to ports and adaptors, and a lot of honest attempts at it. The hexagon gets drawn. The interfaces get defined. Everyone nods along. And then someone has to actually _build_ the thing - construct the objects, connect them together, set it running - and that is where the discipline quietly falls apart. A dependency gets `new`ed up in the middle of a handler because it was easier than threading it through. The construction of a single object ends up smeared across a dozen files. A use case reaches sideways into another use case. None of it shows up in the architecture diagram, which still looks lovely - it shows up six months later, when a change that should have taken an afternoon takes a fortnight.

The architecture doesn't rot in the design. It rots in the wiring. So this is the part where I'm going to be most opinionated, because this is the part that actually protects everything the design promised.

### Ordering

The out-adaptors - the concrete implementations of the out-ports - are the _first_ things your application has to create. Everything else leans on them: the application services and use cases all depend on the out-ports, and ultimately your domain in action is just out-ports plus business logic. So the out-ports come first, and we work our way up from there. They are the rock upon which you will build your church, they are the place you will stand to move the world.

We are going to call each part of this "building-up" from the out-ports a _layer_, in honour and reference to layered architecture, and also because that's really what's happening: we're building our ports-and-adaptors application in layers. Because it's easy to think about it in that way, and harder to mess up, and harder to start leaking things between the layers if you can actually see the bloody layers.

What follows is a single idea applied over and over: an object is responsible for building the objects in a single layer, and it builds that layer by wiring together the objects of the layer below.

And to stop us from getting lost, we'll bundle together all the objects of each layer into a single fat object and pass that around (instead of having a method call with like xity billion arguments).

#### `Bootstrap`

At the very bottom you need something to provide the raw materials for the out-ports. Call it `Bootstrap`.

`Bootstrap` reads the configuration - the environment variables, the database connection strings, the URIs - and hands out the HTTP clients you'll need to build the out-adaptors. It's the one and only place that touches the messy outside-configuration world, so the rest of the wiring doesn't have to.

#### The `OutPorts` Interface

We want to build all the out-ports together, in one place, and then hand them to the layer above. So we give them a home: an `OutPorts` interface that exposes every out-port the application has.

It has to be an interface, because every out-port is an interface - that's dependency inversion at work, and it's why the domain never has to know what's actually implementing its out-ports. `OutPorts` needs _at least_ one real implementation, built up from the `Bootstrap` components - let's call it `BootstrappedOutPorts` - which constructs the out-ports the real life production application runs on. There may be others - there _will_ be others - but we'll get to them when we talk about testing.

#### The `UseCases` /  `Application` object

Same move again: we build `UseCases` from `OutPorts`. This object represents every use case the application has, and a use case, remember, is just an in-port. Its implementation is a `CommandHandler` or a `QueryHandler`.

You might have expected an `ApplicationServices` layer to appear here, in between. It doesn't. Application services aren't a layer - they're the shared bits of logic we lift out of the use cases, and they get constructed _in this same step_, from the out-ports, and handed to whichever use cases need them. They sit below the use cases, not between them and the out-ports. Wiring them as their own rung is exactly the mistake that leads someone to think they can be swapped, or faked, or mocked. They can't. The only thing we ever fake is an out-port.

`UseCases` is _not_ an interface. There should be exactly _one_ way for the application to be used - the domain types are always used the same way - so there's nothing to abstract over. (The individual use cases _are_ interfaces, mind you. That's dependency inversion again).

This layer could properly be called the `Application`, because it's where the domain model is finally applied to solve the business problem. If you gather all the use cases behind a single interface, I'd recommend calling it the `Application`.[^hub] 

#### The `Adaptors` (`HttpAdaptors`) object

And once more, from the top: we build `HttpAdaptors` from `UseCases`. In an HTTP application these are the adaptors that turn a request into a response - the router, the handlers, the controllers. They're the in-adaptors of the use cases.

Like the layers below, this object is concrete, and it's tied to _how_ the application faces the world: HTTP here, but it could just as well be a command line, a desktop UI, or something embedded. The rule of thumb is one use case to one route.

Bundling this all up, in HTTP with routing, the final interface we have is very simple:

```
Request -> Response
```

Once we've got this, we can set it running in a context - for HTTP, that's the internet, so we start listening for those requests on a port - and the application is alive.

### Overview

So the whole startup, from nothing to running, is:

1. Build `Bootstrap` from nothing.
2. Build `OutPorts` from `Bootstrap` (as out-adaptors).
3. Build `UseCases` - the Application - from `OutPorts` (extracting any shared logic into application services as you go).
4. Build `HttpAdaptors` (or whatever other in-adaptors) from `UseCases`.
5. Start the app.

```mermaid
flowchart TD
    Bootstrap["Bootstrap<br>(env config, HTTP clients)"]

    Bootstrap -->|"is used to construct"| BOP["BootstrappedOutPorts"]
    BOP -. "implements" .-> OP["OutPorts<br>(interface)"]

    OP -->|"is used to construct"| UC["UseCases<br>(application services<br>extracted within)"]
    UC -->|"is used to construct"| HA["HttpAdaptors"]
    HA -->|"starts"| App["▶ Running Application"]
```

This same ordering happens whether you're starting the real thing or standing up a slice of it - and a slice can start and stop at different points along the chain. That flexibility is where a lot of the value hides - enough that it gets [its own post](/posts/2026/7/3/how-do-you-test-a-ports-and-adaptors-application).

To reiterate: I call each of these steps a _layer_, in the layered-architecture sense. And underneath all of them sits the domain: its types are used at every single layer.

#### Where does this code live?

Each of those "build the next layer from this one" steps is a function or a constructor, and it's worth being clear about where those functions belong - because it isn't where you might first reach for.

They are not part of the application, and they are certainly not part of the domain. A function that takes `OutPorts` and hands you back `UseCases` is _wiring_ - it's infrastructure, the same species of code as the thing that reads your config, the thing that builds `Bootstrap`, and the thing that opens a socket and starts the server listening. So that's where it lives: in the same packages, the same folders, as the rest of your infrastructure. Right at the edge, next to `main`.

This matters because it keeps the temptation out of the domain. The domain and the application never construct their own dependencies; they're _given_ them. The knowledge of how everything is assembled lives in exactly one place, out at the edge, and the inner layers stay blissfully ignorant of it. If you ever find a wiring function reaching into the domain package, something has gone wrong.

## So why be this fussy?

All of this - the strict order, the fat objects per layer, the one and only one place where each thing gets built - is a lot of ceremony for something as dull as constructing objects. So let me say why it earns its keep.

The wiring is the one place that can quietly undo the whole architecture. The design is just a picture until something builds it, and if the building is sloppy - dependencies conjured mid-handler, construction smeared everywhere, layers leaking into each other - then the lovely hexagon is a lie. You won't notice for a while. You'll notice the day a simple change fights back.

Do it the disciplined way and the opposite happens: the seams stay real. Because each layer is built from the one below and handed up whole, you can stop the process at any layer you like - which is exactly the trick that makes the whole thing testable. Stand the out-ports up as fakes, build the real use cases on top of them, and drive them directly. That's [the next post](/posts/2026/7/3/how-do-you-test-a-ports-and-adaptors-application).

[The architecture was the easy part](/posts/2026/7/2/the-architecture-is-the-easy-part). This was the bit that makes it true.

[^hub]: I've seen it called a `Hub` before in some situations - you can picture it as the bit in the middle of the hexagon where the individual use cases form the spokes of a wheel - but I think this muddies things too much with a new word.

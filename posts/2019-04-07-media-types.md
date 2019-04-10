---
title: "Why learn... about Media Types"
published: false
date: 2019-04-07 19:12:28
description:
tags:
  - web
  - beginners
---

Media types are used to communicate the type of data being sent over the
web. They are used

- in an HTTP response to declare the type of content being sent
- in requests to declare what sort of content the client can interpret
- in POST requests to declare the type of content being sent.

Basically, wherever there is data on the web, there will be a media type to tell
you what it is. And if there's not there really ought to be.

This article will explain how to interpret a media type and also explain how
they are used in HTTP headers to make sure we get the data that we can
understand.

- [Who is this for?](#who-is-this-for)
- [Where Have I seen Media Types Before?](#where-have-i-seen-media-types-before)
- [Media Type Syntax](#media-type-syntax)
- [Media Types in HTTP Message Headers](#media-types-in-http-message-headers)
- [Content Negotiation](#content-negotiation)
- [Summary](#summary)
- [Q and A](#q-and-a)

## Who is this for?

This is for web developers who are interested in understanding how content works
on the web. Some knowledge of HTTP, specifically headers, us useful but not
necessary.

## Where Have I Seen Media Types Before?

The first time I saw a media type was when I wrote my first HTML file -
specifically to get some CSS:[^1]

```html
<link rel="stylesheet" src="style.css" type="text/css" />
```

There's our first media tyep - `text/css`.

The next place I bumped into them was when I was returning JSON from a server:

```
response.contentType = "application/json"
```

There's another one - `application/json`.

So they're not completely alien to us - they're a way of saying that "the file
is full of CSS", and "I'm sending you some JSON". They describe

### Wait, don't you mean MIME types?

No, I don't. MIME means _Multipurpose Internet Mail Extensions_ and was the
first place that media types were used. But since they're not used solely for
'internet mail' (email to you and me), the proper name is 'media type'. People
still tend to use them interchangably, but now you know the right answer you can
look smug at parties and demand a pay rise.

Right, let's get stuck into the details

## Media Type Syntax

A media type is made up - a minimum - of two fields separated by a `/`. The
first is the `type` and the second is the `subtype`.

So, straight off we can see that CSS (`text/css`) has a type of `text`, and a
subtype of `css`. The `text` type is very broad - it's just text after
all. Other subtypes of text are:

- `text/html` - it's what you're reading right now!
- `text/plain` - it's just plain text!
- `text/markdown` - what I'm writing this in
- `text/csv` ...

you get the idea.

`application/json` has a subtype of `json` - that makes sense. The `application`
type informs us that this is a type that's meant to be processed by a
application. This kinda makes sense, as it's JSON, which is meant to be read by
computers.

(But isn't CSS only meant to be processed by an application? Yes, it is. Media
types are a bit wonky. Don't worry about it too much. Part of being a web
developer is learning to live with a fair amount of kludge and ambiguity. Learn
to live with it.)

Other fun `application` types are

- `application/pdf` for PDFs
- `application/zip` for zip files
- and many, many more...

### All the types

We've seen `text` and `application` types - here's a list of types that you're
likely to come across with examples:

| type | purpose | example |
|:-------------:|:------------------------------------:|:---------------------:|
| `application` | media for application consumption | `application/json` |
| `audio` | audio media | `audio/mp3` |
| `font` | font formats | `font/ttf` |
| `image` | visual media | `image/gif` |
| `multipart` | media that needs to be sent in parts | `multipart/form-data` |
| `text` | plain text | `text/html` |
| `video` | video media | `video/mp4` |

Type and subtype are the only parts of a media type that are required, but there
are also couple of optional parts.

### Parameters

Media types can have optional parameters tagged on to them after a
semicolon. For instance `text/plain;charset=UTF-8` is a `text/plain` media type
that's using the UTF-8 character encoding. If we want our sweet emojis we need
to remember this stuff to say we're using UTF-8, or else everyone will assume
we're writing in ASCII like it's the 1970s or something.

### Structured Syntax Name Suffix

This one's a bit weird, but bear with me. Take a look at this media type:

```
image/svg+xml
```

This is the type for SVG images - Scalable Vector Graphics. But what's the
`+xml` doing there? Well, as you may already know, SVG files are written in
XML - it's one of the nicest things about them. So the `+xml` is telling us that
the syntax of SVG is XML. This is called the 'structured syntax name', and it's
a nice way of letting us know that, hey, you may not know what SVGs are but,
it's ok, it's just XML so you'll be fine.

(Unless you're me and you panic everytime you hear the word XML and wish that
the world was written in JSON, but that's another story...)

---

Look, I can tell you're really excited by all these media types. Now you know
how to read them, you can read the [list of all the media types][IANA] that have
been registered with IANA, the Internet Assigned Numbers Authority.

## Media Types in HTTP Message Headers

The most important place you'll use media types is in HTTP messages. You'll use
them to describe the media type of the data you want in the `Accept` header of
an HTTP Request, and the type of data you're sending in the `Content-Type`
header of an HTTP Response.

### The `Accept` Header

The `Accept` header is the way a client - like your browser - can tell a server
what sort of content it wants.

At it's simplest it can look like this:

```
Accept: application/json
```

If I put this in the header of my request, I'd be making it very clear to the
server that I want JSON back. No questions asked.^[2]

But say you wanted some audio back from the server, but didn't mind what
subtype - `audio/mp3` is just as good as `audio/wav` for you. In this case you
can say:

```
Accept: audio/*
```

`*` represents a wildcard - it means 'give me anything'. The server could
legitimately reply with an `audio` media type with _any_ subtype.

Finally, if you just don't care what comes back from the server you can just say

```
Accept: */*
```

### The `Content-Type` Header

`Content-Type` is the header you should add to an HTTP Response message to tell
the client what they're getting in the response body. This is how the client
knows how to interpret the message that you're sending.

The `Content-Type` header should have one media type, so it could be as simple
as this:

```
Content-Type: text/html
```
### Wait, can't I just use a file extension?

You can imagine that you've got some data that you can get to through a URL:

```
http://gypsydave5/data
```

Maybe if I wanted to get the data as JSON I could request:

```
http://gypsydave5/data.json
```

But if I want XML instead I could do:

```
http://gypsydave5/data.xml
```

The benefit being that this is pretty easy to understand if I'm used to using a
filesystem - I can just identify the type of file by the extension, and so I
cacn now do the same with a URL.

What's the harm? Probably the most annoying thing is that, even if you provide
an extension as above, you'll _still_ have to provide a `Content-Type`
header. This is because, on the web, information about content isn't meant to be
encoded in URLs; it's meant to be in the `Content-Type` header.

Some popular frameworks do this,[^6] but it's a bad idea. Don't do it.

The biggest problem is that you'll miss out on being able to perform _content
negotiation_.

## Content Negotiation

Pretend you're going to a sandwich shop and your friend asks you to get a
sandwich. Sure, you say, what do you want? I don't know, they say, what do they
have? Um... you say, I really don't know - here's the menu but they've often run
out of some of the fillings by this time of day.

OK, says your friend, here's what I'd like:

>"I want tuna mayo or a New Yorker - either is fine. If they don't have those,
>then I'll take an egg salad. And if they don't have an egg salad, then please,
>get me anything - I'm starving."

Doesn't sound too bad. You can use your friend's set of sandwich requirements
when you get to the sandwich shop to get them a sandwich that they'll like.

The same thing happens every day on the web, with clients sending a list of
media types over to servers to try and make sure that they'll get something they
like. Take a look at this `Accept` header of an HTTP Request sent from a web
browser:[^3]

```
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
```

The browser wants one of the above media types. But it's got some opinions about
which ones it would prefer, which it's expressing using `q` parameters.[^4] `q`
parameters have a value between `1` and `0`, and the default value of a `q`
parameter (when it's not supplied) is `1`.

Here's the media types above written out with their `q` values.

| media type | q value |
|-------------------------|---------|
| `text/html` | 1.0 |
| `application/xhtml+xml` | 1.0 |
| `application/xml` | 0.9 |
| `*/*` | 0.8 |

A series of choices ranked by preference. If you or I were going to the server
to get the browser some content, the browser would tell us something like:

>"I really want `text/html` and `application/xhtml+xml`. But, if they don't have
>those, I'd go for some sweet `application/xml`. And if they don't have that
>then, whatever, just get me anything."

Which is really what you'd want a browser to do - you always want to get
_something_ back.

```
Accept: audio/*
```

Is like we're being sent to the record store:

> "Could you get me the new Nirvana album?[^5] I don't care if it's on vinyl,
> tape or CD. Hell, 8 Track will do. Just make sure I can listen to it, OK - I
> don't just want the poster."

This is _content negotiation_ - our request to the server has given it our
preferences regarding the content type we get back. It can go through those
prefences, looking at what content types it can return, and give us the type
that matches the most closely.

## Summary

We've learned:

- How to understand the syntax of a media type.
- How to use them in `Content-Type` headers to declare what we're sending.
- How to use them in `Accept` headers to control the content type we get back.
- How to use them to perform content negotiation with a server.

Media types are important - they help smooth the path of passing data around on
the web. Get into the habit of using them whenever you can.

## Q and A

> Q: "Wait, I did't put a `Content-Type` header on the HTML I sent but my
> browser still knew it was HTML - what gives?"

A: There are ways of working out the media type of data; go read up on [content
sniffing][sniff].

> Q: Can I make up my own media types?

A: You sure can! Lots of developers write their own `application` media types to
describe the type of data they're sending -
e.g. `application/x-daves-app+json`. The `x` is important if you're just
[experimenting][x], but if your application accepts or sends a custom media type
with the rest of the web, you could [register it with IANA][register] for
eternal fame!

[^1]: This is HTML4 - you don't need to include the type in HTML5. But that would ruin this perfectly good example.

[^2]: In fact the server should send back a 406: Not Acceptable code if it can't supply the media type asked for... but this rarely happens.

[^3]: In this case Firefox.

[^4]: The `q` stands for quality. I'm not even joking.

[^5]: I am very much down with popular culture.

[^6]: [Active Resource in Rails](https://github.com/rails/activeresource)

[IANA]: https://www.iana.org/assignments/media-types/media-types.xhtml
[sniff]: https://en.wikipedia.org/wiki/Content_sniffing
[x]: https://tools.ietf.org/html/rfc4288#section-3.4
[register]: https://www.iana.org/form/media-types

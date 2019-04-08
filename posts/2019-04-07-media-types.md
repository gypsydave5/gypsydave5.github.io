---
title: "Why learn... about Media Types"
published: false
date: 2019-04-07 19:12:28
description:
tags:
  - web
  - beginners
---

Media types are used to communicate the type of data being sent over the web. They are used

- in an HTTP response to declare the type of content being sent
- in requests to declare what sort of content the client can interpret
- in POST requests to declare the type of content being sent.

Basically, wherever there is data on the web, there will be a media type to tell you what it is. And if there's not there really ought to be.

This article will explain how to interpret a media type and also explain how they are used in HTTP headers to make sure we get the data that we can understand.

- [Who is this for?](#who-is-this-for)
- [Where Have I seen Media Types Before?](#where-have-i-seen-media-types-before)
- [Media Types in Depth]
- [Media Types in HTTP Headers]
- [Content Negotiation]
- [Summary]
- [Further Reading]

## Who is this for?

This is

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

| type          | purpose                              | example               |
|:-------------:|:------------------------------------:|:---------------------:|
| `application` | media for application consumption    | `application/json`    |
| `audio`       | audio media                          | `audio/mp3`           |
| `font`        | font formats                         | `font/ttf`            |
| `image`       | visual media                         | `image/gif`           |
| `multipart`   | media that needs to be sent in parts | `multipart/form-data` |
| `text`        | plain text                           | `text/html`           |
| `video`       | video media                          | `video/mp4`           |

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
a nice way of letting us know that, hey, you may not know what SVGs are but, it's
ok, it's just XML so you'll be fine.

(Unless you're me and you panic everytime you hear the word XML and wish that
the world was written in JSON, but that's another story...)

---

Look, I can tell you're really excited by all these media types. Now you know
how to read them, you can read the [list of all the media types][IANA] that have
been registered with IANA, the Internet Assigned Numbers Authority.

## Media Types in HTTP Headers

The most important place you'll use media types is in HTTP messages. You'll use
them to describe the data you want, and the data you're sending.

### This stuff is...: The `Content-Type` Header

`Content-Type` is the header you should add to an HTTP Response message to tell
the client what they're getting in the response body. This can be vital - how can the client know how
to interpret the message that you're sending unless you tell it what the format
of the message is? It could end up trying to parse XML as JSON, or rendering an
MP3 file as HTML. Madness and chaos ensues!

The `Content-Type` header should have one media type, so it could be as simple
as this:

```
Content-Type: text/html
```

You can also add the character set as a parameter.

### I want this stuff: The `Accept` Header

This is the counterpart to `Content-Type`, it's the way a client - like your
browser - can tell a server what sorts of media it wants.

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

What's the harm?

It's not great because you've ended up coupling the URL, which should be
something abstract, to a concrete data type. It's asking for trouble if you
start to add new types of media under the URL. You also have to work out how you
handle requests to the bare URL, and also how you'll handle requests with
`Accept` headers set. What if you ask for XML from the `.json` route?

Some popular frameworks do this,[^6] but it's still a bad idea.

## Content Negotiation

But in the real world things can be a bit more complicated. Take a look at
the `Accept` header of an HTTP Request sent from a web browser:[^3]

```
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
```

The browser wants us to know that it would like one of the above media
types. But it's got some opinions about which ones it would prefer, which it's
experssing using `q` parameters.[^4] `q` parameters have a value between `1` and
`0`, and the default value of a `q` parameter (when it's not supplied) is `1`

So the above Accept header could be written out like this:

| media type              | q value |
|-------------------------|---------|
| `text/html`             | 1.0     |
| `application/xhtml+xml` | 1.0     |
| `application/xml`       | 0.9     |
| `*/*`                   | 0.8     |

A series of choices ranked by preference.

This is something like what happens when you ask a friend to buy you a
sandwich:

>"I want tuna mayo or a New Yorker. If they don't have either of those, I'll take egg salad. And if they don't have any of that, then please, get me anything - I'm starving."

in HTTP land:

>"I really want `text/html` and `application/xhtml+xml`. But, if you don't have those, I'd go for some sweet `application/xml`. And if you don't have that then, whatever, just give me anything that's going."

Which is really what you'd want a browser to do - you always want to get
_something_ back.

```
Accept: audio/*
```

Translates as

> "Could you get me the new Nirvana album?[^5] I don't care if it's on vinyl, tape or CD. Hell, 8 Track will do. Just make sure it's not a t-shirt or something weird."

All of the above is called _content negotiation_ - our request to the server has
given it our preferences regarding the content type we get back. It can go
through those prefences, looking at what content types it can return, and give
us the type that matches the most closely.


[^1]: This is HTML4 - you don't need to include the type in HTML5. But that would ruin this perfectly good example.

[^2]: In fact the server should send back a 406: Not Acceptable code if it can't supply the media type asked for... but this rarely happens.

[^3]: In this case Firefox.

[^4]: The `q` stands for quality. I'm not even joking.

[^5]: I am very much down with popular culture.

[^6]: [Active Resource in Rails](https://github.com/rails/activeresource)

[IANA]: https://www.iana.org/assignments/media-types/media-types.xhtml

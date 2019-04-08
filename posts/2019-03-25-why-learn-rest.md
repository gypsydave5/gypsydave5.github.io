---
title: "Why learn... REST? Part 1: Resources"
published: false
date: 2019-03-22 19:12:28
description: Understanding REST for the beginner
tags:
  - beginners
  - architecture
  - web
---

- [Who is this for?](#who-is-this-for)

## Who is this for?

This is for... me! I've been working for however many years and still don't know
how REST is meant to work. You may think REST is about making sure you use POST
for a new 'thing' rather than 'PUT', and 'DELETE' to remove a 'thing' unless
it's from a browser. This is pretty much my position up to a few days ago.

REST is a lot more interesting, and relies on some truly beautiful abstractions.

## The World Wide Web

REST is a model of distributed computing built upon the World Wide Web. So if
we're going to understand REST we're going to need a grasp on how the Web works.
Don't worry, this isn't goind to be the low-level details - we're not going to
be talking about the intricacies of TCP/IP architecture or what an HTTP
message looks like. This isn't technical - if anything it's harder: it's
abstract.

## In the beginning...

When the Web was built there were no abstractions; it was very simple. A Uniform
Resource Locator (URL[^1]) pointed to a file on a computer somewhere else, and when
you requested that URL that file was sent to your computer.

So imagine it's 1995 and you're working at CERN and you want to write a
page. But you've forgotten what all the HTML tags are because there are so many
of them.[^2] So you'd open your web browser, which you wrote yourself because, hey,
you're Tim Berners-Lee now (it's your imagination so why not?), and you type in a
URL:

```
http://info.cern.ch/hypertext/WWW/MarkUp/Tags.html
```

And you get a page of HTML, that you probably wrote, that tells you about HTML
tags that you probably came up with, served up by the web server that you also
wrote because, yes, you're Tim Berners-Lee.

This is the simplest way to think about the Web: you request an HTML document from
a server and it finds that document. The path to the file on the server is
`/hypertext/WWW/MarkUp/Tags.html` - it's just like a directory structure on a
computer.

If you've ever [built a static site][staticSite] this is exactly the type of
behaviour you're used to.

But there's another feature to your web server - the ability to dynamically
create the response that gets sent back. All of a sudden you don't have to have
a file in a directory to send back. It could be anything.

For instance, it could be [a picture of the office coffee machine this
second](https://www.cl.cam.ac.uk/coffee/coffee.html)so you know whether there's
any coffee in it:

```
https://www.cl.cam.ac.uk/coffee/xvcoffee.html
```

or a way to search for pages with a certain word in:

```
http://info.cern.ch/search?term=h3
```

or even just the current time:

```
http://gypsydave5.com/time/now
```

Each of these URLs' responses should be generated on the server. So the URLs are
no longer the paths to a file which is returned when it is requested, they're
... what? What does the URL mean if it is no longer a way of getting a document
from a filesystem? And what do you get if not a document?

## Representations and Resources

What is the current time? Try and pick the right one:

> About half past one

> Thirty-seven minutes past one in the afternoon

> Halb eins uhr

> 13:37

```json
{
    "hour": "13",
    "minute": "37",
    "second": "35",
}
```

> 2019-01-01 13:37:35

> 1546349825

or even

![an analogue clock face showing 13:37](http://todo.com)

All of these could be the current time - they're all correct. But they're all
different in some way.

What is the time? Can you touch it? Can you taste it? Can you show me where it
is?

```
http://gypsydave5.com/dog
```

```
http://gypsydave5.com/dog
```

```
http://pets.org/my-pet
```

[^1]: You will also see the terms _URI_ (Universal Resource Indicator), _URN_
    (Universal Resource Name) and _IRI_ (International Resource
    Indicator). These all have specific meanings and were introduced to try to
    clean up the specification. Some people will now claim to be clever by
    saying that we _should_ say URI rather than URL. But the w3c are nothing if
    not pragmatic about these things; the [living spec][w3cURLgoals] for URLs now says that we
    should "Standardize on the term URL. URI and IRI are just
    confusing". Confusing and only ever used to make some people feel smug and
    other people feel like outsiders so let's just stick with URL.

[^2]: Unless you want to edit the file everytime the time changes. Or you could
    set up a repeating task on the server to change the file.


[w3cURLgoals]: https://url.spec.whatwg.org/#goals

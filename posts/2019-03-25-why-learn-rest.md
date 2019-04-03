---
title: "Why learn... about REST? 1: URIs and Resources"
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
Don't worry, this isn't 'work' as in we're going to be talking about the
intricacies of TCP/IP architecture or even what an HTTP message looks like. This
isn't technical - if anything it's worse: it's abstract.

## The Two Abstractions of the Web: URIs and Resources

When the Web was built there were no abstractions; it was very simple. A Uniform
Resource Locator (URL) pointed to a file on a computer somewhere else, and when
you requested that URL that file was sent to your computer.

So imagine it's 1995 and you're working at CERN and you want to look at some
jokes because building a LHR is a bit stressful. So you'd open your web browser,
which you wrote yourself because, hey, you're Tim Berners-Lee now (why not it's
your imagination), and you type in
a URL:

`http://cern.org/tblee/jokes.htm`

And you get some jokes. Great.

Fast forward a few years and



## Representations

```
http://gypsydave5.com/dog
```

```
http://gypsydave5.com/dog
```

```
http://pets.org/my-pet
```

---
layout: post
title: "Life on Hard Mode: The C Programming Language"
date: 2016-05-26 22:35:20
tags:
    - C
    - Languages
    - Learning
published: false
---

I've started to learn C. There's a number of reasons for this. First, it was the
'proper' programming language when I was a kid. Second, I've been learning quite
a bit of Go recently, and just about every other page on the excellent Go Blog
has a sentence that starts with "In C...".

Third, I've started a course on [Data Structures and Algorithms] on [Coursera],
inspired by the ever-inspirational [Denise Yu]. The course only accepts
submissions in four languages: Python, Java, C++ and C.[^1] Going through that
list my mind went "Basically Ruby with _bleaugh_ indentation, _bleaugh_ Java
_bleaugh_, sounds really hard, sounds hard." So I went with 'sounds hard' - and
I'm really glad I did.

I thought I'd try and capture my process of learning C from a Ruby/JavaScript
background as it might be useful to other developers in a similar position
- people with no CS background but who do know how to program. I'll be
approaching this in a series of posts, most of which will be following
[a presentation I gave on C][presentation].[^1]

## Why C is Great

When I learn a programming language, I find it illuminates features across all
languages, making me better across the board. C is the most extreme example of
this principle because (and I don't think I'm exaggerating when I say this) it
is the wellspring from which all other languages come.[^2] The constructs and
features we can see in Java, Ruby, Python, JavaScript, etc... all come from the
C.

For example, I wanted to sort an array in C. So I hit the internet, and it
returns me the function `qsort()` from the C standard library. The function
takes an array (figures).

Maybe I hate myself

[^1]:
[^2]: Other than Lisp. Obviously.
[presentation]: http://blog.gypsydave5.com/the-c-programming-language-presentation/


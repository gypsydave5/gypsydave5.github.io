---
layout: post
title: "The C Programming Language Part Two: Types"
date: 2016-07-31 13:58:26
tags:
    - C
    - Languages
    - Learning
published: false
---

_This post follows on from my [first post about the C programming language], and
is a part of a series of posts about learning C_

C is a 'strongly' typed language, but what does that mean? This post is going to
focus on types in C and the role they perform in that language. We're going to
show how they're used in C but, more importantly, we're going to look at why
they're used in C and consider what sort of things they make easier in C as well
as harder.

## All the types

A type in C is a type of _data_, a particular sort of data. For instance, if you
want to talk about a whole number in C you may wish to use an `int`, whereas if
you want to use a decimal number you would need to use a different type of data,
say a `float`.

The first temptation to avoid, definitely from my Ruby brain, is to think of
types as being like classes. Types are just ways of storing data in a computer
as will become clear.

C has `int`, a type that will store an integer. But it also has `long`, which
will store a bigger integer, and, on top of that we have `long long`, which will
store a _really_ big integer. And if you just happen to know that the number you
want to store is _really_, _really_ big but will never be negative, you can go
so far as to use the type `unsigned long long`.

This all sounds a little ridiculous, especially from the point of view of
a Rubyist or a JavaScripter - I mean, I see why maybe a `float` is different to
an `int`, but why do I need all these different ways to talk about integers?

The reason cuts to the heart of what a type system is for, and why C is a lower
level programming language than Ruby.

## Memory management

In C when we declare a variable we declare it with its type:

```clang
int my_number;
```

We can then assign a value to it:

```clang
int my_number;
my_number = 5;
```

In Ruby, you'd just need the second line, and in JavaScript it would be the same
but `int` would be `var`.[^1] But what's going on under the hood of your
computed when you ask for a variable.

This is the bit where I remember the video of the American politician explaining
that the internet is a series of tubes. Well, I'm about to be just a reductivist
and say that your computer's memory is a big long line of ones and zeroes.

![a series of empty boxes](/images/a-series-of-empty-boxes.png)

Each one of these ones and zeroes is called a _bit_ (Binary DigIT - geddit?). And
eight of those in a row is called a _byte_ (no idea, you look it up).


[^1]: Or you could do it in a single line, `var number = 5`, which some versions of C will also let you do: `int number = 5`


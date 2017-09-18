---
layout: post
title: "Lambda Calculus 2 - Church Numbers"
date: 2017-09-11 20:54:21
tags:
    - Mathematics
    - Functional Programming
    - Lambda Calculus
published: false
---

I'm reading (_The Structure and Interpretation of Computer Programs_)[sicp].
It's hard - my maths is terrible in comparison to what was expected of Computer
Science undergraduates at MIT in the 80s. But I'm learning some things, and one
of the things that clicked today near the end of the first section of Chapter
2 was Church numerals.

## Counting... without numbers

What's a number? No really, what is it? Well, there are lots of different sorts
of numbers so let's just start off with the non-negative integers - 0 and
upwards. The Natural numbers.

What can we use to define these numbers? We could



In the [first post I wrote about the lambda calculus][lambda-1] we looked at the basic
syntax and a simple function that took two numbers and added them together:

```
λx.λy.x + y
```

This might all look OK until I tell you that, in the untyped lambda calculus,
the only primitive data type is a function.

A function. Not a bit, a byte, a string; not a number - a function.

So we should be a little suspicious of `λx.λy.x + y` as this `+` symbol needs to
be defined as a function. Fair enough - addition feels like a the sort of thing
that could easily be a function.

But what would we apply to it? We need a number - like 1 or 2. But we need to
make them out of functions.

Wait, what? We need to make numbers _out of functions?!_

And this is where things start to get weird.

## What is a number anyway?

You will now be inducted into a sacred Lispy mystery that will allow you to make
and understand geeky jokes on the internet[^1]. Be brave.

In a universe with no things - only functions - how would we count? Well, we'd
have to do it with functions.

OK, sure - that's not really getting us anywhere - let's take `2` as a concrete
example. How do I write a function that represents `2`?

Simple - we just give it a name if it was JavaScript:

```javascript
const two = () => {}
```

That's cheating! What are these 'names' of which you speak? Are they made of
functions too?

The thing is, we don't just want a symbol for `2` - the numeral. What we need
is a function that expresses the very essence of two-ness.

What I'm trying to get across here (without jumping to the solution
immediately) is that the representation of numbers in the lambda calculus are
not mere symbols; they encapsulate a certain behaviour that we associate with
'number'.

And that behaviour is that of _repetition_. When we say 'look at those two
apples', we're expecting there to be an apple, and then _another_ apple. In
Church arithmetic a number is represented by a function that takes two values,
and then applies the first value to the second value n times, where 'n' is the
number being represented.

## Church Numbers

So much for the theory, let's take a look at some 'real' numbers[^2]. First up, the
number one:

```
λf.λx. f(x)
```

We accept a variable called `f`, we take another one called `x`, and we call `f`
with `x` once. We're kinda hoping that `f` turns out to be a function, but as
this is the lambda calculus and _everything_ is a function, we can be ~fairly~
absolutely certain it is.

In JavaScript:

```javascript
f => x => f(x)
```

And Scheme:

```scheme
(lambda (f) (lambda (x) (f x)))

```

So if that's one, we can probably work out what two is, right?

```
λfx. f(f(x))
```

And three?

```
λfx. f(f(f(x)))
```

OK, so no peeking now. What's zero?

...

...


```
λfx. x
```

It's just ignoring the original function and returning the value it would've
been applied to - it's applied zero times.

## Playing around

I find there to be two productive ways to play around with the lambda calculus
when I've been learning it.

Firstly, and probably more obviously, try plugging around with them in your
favourite language. Say Python - if we were to write `three` from above we'd
have:

```python
lambda f: lambda x: f(f(f(x)))¬
```

If I want to test this - to see if it does what I think it does - I just need a
function to be `f` and some value it can be repeatedly applied to.



In JavaScript:

```javascript
f => x => x
```

And Scheme:

```scheme
(lambda (f) (lambda (x) x))

```





[^1]: It's amazing how much of a driver to education understanding jokes can be
[^2]: I mean, actually these are the natural numbers including zero, not the real numbers
[^3]: You could do this with `def`s, but this is the _lambda_ calculus after all

[sicp]: https://mitpress.mit.edu/sicp/
[lambda-1]: {% post_url 2017-09-11-lambda-calculus %}

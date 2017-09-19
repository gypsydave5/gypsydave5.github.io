---
layout: post
title: "Lambda Calculus 2 - Church Numbers"
date: 2017-09-13 20:54:21
tags:
    - Mathematics
    - Functional Programming
    - Lambda Calculus
published: true
---

I'm reading [_The Structure and Interpretation of Computer Programs_][sicp].
It's hard - my maths is terrible in comparison to what was expected of Computer
Science undergraduates at MIT in the 80s. But I'm learning some things, and one
of the things that clicked today near the end of the first section of Chapter
2 was Church numerals.

## Counting... without numbers

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

You will now be inducted into a sacred mystery that will allow you to make and
understand geeky Lisp jokes on the internet. Be brave.

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

The thing is, we don't just want a _symbol_ for `2` - the numeral. What we need
is a function that represents, in some way, the very essence of two-ness.

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

So much for the theory, let's take a look at some real numbers.[^2] First up, the
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
been applied to. The function `f` has been applied to `x` zero times.

## Playing around with the computer

I find there to be two productive ways to play around with the lambda calculus
when I've been learning it.

Firstly, and probably more obviously, try plugging around with them in your
favourite language that has some sort of anonymous function. Say Python - if we
were to write `three` from above we'd have:

```python
three = lambda f: lambda x: f(f(f(x)))
```

If I want to test this - to see if it does what I think it does - I just need a
function to be `f`:

```python
increment = lambda x: x + 1
```

and some value it can be repeatedly applied to:

```python
zero = 0
```

So then I just plug in those values:

```python
three(increment)(0) #=> 3
```

We used three variables to hold the values above, but we could just inline them
to get to something that looks a little more lambda-y:

```python
(lambda f: lambda x: f(f(f(x))))(lambda x: x + 1)(0) #=> 3
```

Which translates to:

```
(λfx. f(f(f(x)))) (λx. x + 1) 0 = 3
```

We don't have to use `zero` and increment however - we could count using any
values that behave in the required way.[^5] For instance:

```scheme
(define increment (lambda (x) (cons '() x)))

(define zero '())

(((lambda (f) (lambda (x) (f x))) increment) zero) ;=> (())
(((lambda (f) (lambda (x) (f (f x)))) increment) zero) ;=> (() ())
(((lambda (f) (lambda (x) (f (f (f x))))) increment) zero) ;=> (() () ())
```

## Playing around with pen and paper

The second way I like to play with lambdas is with pen and paper. The simplicity
of the syntax, and the very few transformations allowed on an expression[^4], mean
that it's possible to do the evaluation yourself. Let's try it with the above:


```
(λfx. f(f(f(x)))) (λx. x + 1) 0
```

```
(λx. (λx. x + 1)((λx. x + 1)((λx. x + 1) x))) 0
```

```
(λx. (λa. a + 1)((λb. b + 1)((λc. c + 1) x))) 0
```

```
(λa. a + 1)((λb. b + 1)((λc. c + 1) 0))
```

```
(λa. a + 1)((λb. b + 1)(0 + 1))
```

```
(λa. a + 1)((λb. b + 1) 1)
```

```
(λa. a + 1)(1 + 1)
```

```
(λa. a + 1) 2
```

```
(2 + 1)
```

```
3
```

This is fun to try out, and while it's not much help when the expression is
relatively simple as the one above, it gets pretty vital for me when I want to
discover how more complicated expressions work.

In summary, the computer is great for checking that a lambda expression works,
but I prefer to do get the pen and paper out if I want to get a feel for what's
going on - for what makes it work.

## But ...

But what about the `+` and `1` and `0` above? I said that there were only
functions in the lambda calculus, aren't we still cheating a little bit.

We are. So in the next post let's define `increment`, `add`, `multiply` and
maybe even `exponentiation` in terms of lambdas. Things are certain to get
weirder.


[^2]: I mean, actually these are the natural numbers including zero, not the real numbers
[^3]: You could do this with `def`s, but this is the _lambda_ calculus after all
[^4]: α-conversion and β-reduction - see [the first post][lambda-1]
[^5]: I am thoroughly in debt to the amazing book [_The Little Schemer_][schemer] for the inspiration behind this example.

[sicp]: https://mitpress.mit.edu/sicp/
[lambda-1]: {% post_url 2017-09-11-lambda-calculus %}
[schemer]: https://mitpress.mit.edu/books/little-schemer

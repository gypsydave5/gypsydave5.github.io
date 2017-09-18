---
layout: post
title: "Lambda Calculus 1 - Syntax"
date: 2017-09-11 20:54:21
tags:
    - Mathematics
    - Functional Programming
    - Lambda Calculus
published: false
---

The word lambda comes up more and more the longer you work as a
programmer. There it is as a keyword in Python for an anonymous function. Same
again in Scheme. Look at the logos for (almost) ...

Whatever, lame intro.

Alonzo Church came up with the lambda calculus as a part of his investigations
into the foundations of mathematics. The same sort of investigations led Alan
Turing to the thought experiment of the Turing machine.

In a way, the lambda calculus is to functional programming as the Turing machine
is to working with computer memory; an abstract model.

In another way it's they're both insights into THE VERY NATURE OF REALITY ITSELF.

Ok, enough of the blurb.

## Syntax

The lambda calculus gets its name from its use of the Greek letter lambda -
`λ` to represent a function that takes a single argument.

After the `λ` comes the name that that single argument is bound to - say `x`.

And after that we write a `.` to say that we're inside the 'body' of the function.

The `x` is a bound variable - it stands for some value that the function can be
applied to.

And to apply a value to a function, you call it by putting them next to each
other (maybe with some brackets to make it clearer what's the value and what's
the body).

That's it. That's everything in the lambda calculus - it's a syntax for writing
about functions of one argument.

So where in JavaScript we have:

```javascript
x => x + 1
```

and in Scheme we have

```scheme
(lambda (x) (+ x 1))
```

in the lambda calculus syntax we have:

```
λx.x + 1
```

## Only one argument?

So you might see some limitations here.Only one argument, you may say, what
if I need another one? Happily we can just return another function to bind a new
argument. Hooray - everything is [curryed][currying].

So where in JavaScript:

```javascript
x => y => x + y
```

and in Scheme:

```scheme
(lambda (x) (lambda (y) (+ x y)))
```

so in the Lambda calculus we have:

```
λx.λy.x + y
```

Although usually[^1] we'd just write:

```
λxy.x + y
```

But we would of course remember that, if the function had only one argument
applied to it, it would return a function that expected the next argument.

## α-conversion and β-reduction

These terms do absolutely nothing to dispell the feeling that the lambda
calculus is a bit elitist. Look, even more Greek letters - it must be
complicated and clever because just writing about it requires me to know how to
say `α`!

Really though, these are just big words for 'substitution' and 'application',
the basics of which you probably picked up in high school algebra.

'α-conversion' (alpha-conversion) just means that we can change the name of a
bound variable in a Lambda expression. So if we've got:

```
λxy.x + y
```

We can just change all the `x`s to `a`s

```
λay.a + y
```

And the expression hasn't changed in its meaning one iota.[^2]

'β-reduction' (beta-reduction) is a little more complicated - what it means is
that, when a value is applied to a function, we can substitute all the variables
that name that argument with the value the function is applied to. For instance,
in JavaScript:

```javascript
(x => y => x + y)(5)
```

under β-reduction becomes

```javascript
y => 5 + y
```

We unwrap the outer function and replace occurances of its variable with the
supplied value. In lambda land:

```
(λxy. x + y) 5
```

Becomes

```
λy. 5 + y
```

(I threw some parentheses around that other Lambda expression to make it clear
that the `5` was getting applied to the whole function and to separate it from
the body `x + y` - there's no hard and fast rules as far as that goes).

Next up - [numbers made of functions][lambda-2]!


[^1]: To save on the world's dwindling supply of `λ`s
[^2]: Aaaargh! _Another_ Greek letter!

[currying]: {% post_url 2015-02-19-not-quite-js-currying %}
[lambda-2]: {% post_url 2017-09-11-church-numbers %}

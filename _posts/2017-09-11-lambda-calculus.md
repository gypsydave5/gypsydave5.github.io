---
layout: post
title: "Lambda Calculus 1 - Syntax"
date: 2017-09-11 20:54:21
tags:
    - Mathematics
    - Functional Programming
    - Lambda Calculus
published: true
---

The word 'lambda' comes up more and more the longer you work as a
programmer. There it is as a keyword in Python for an anonymous function. Same
again in Scheme. Oh look, there it is in Ruby. Look at the logos for Racket,
Clojure, MIT. Lambdas everywhere. The interest/obsession goes back to the
mathematical roots of Lisp, specifically Alonzo Church's _lambda calculus_.

## Why?

Church was researching the foundations of mathematics - particularly
computation. The notation he came up with is a way of expressing any computation
at all - if a computer can do it, it can be written in the syntax of the lambda
calculus. But, interestingly for us, it is not concerned about _how_ he
computer does it; rather it just has some simple rules about _what_ a
computer can do. It is, if you like, a very simple declarative programming
language.

## Syntax

The lambda calculus gets its name from its use of the Greek letter lambda -
$\lambda$ to represent a function that takes a single argument.

After the $\lambda$ comes the name that that single argument is bound to - say $x$.

And after that we write a $.$ to say that we're inside the 'body' of the function.

The $x$ is a bound variable - it stands for some value that the function can be
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

$$ \lambda x.x + 1 $$

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

so in the lambda calculus we have:

$$ \lambda x.\lambda y.x + y $$

Although usually[^1] we'd just write:

$$ \lambda xy.x + y $$

But we would of course remember that, if the function had only one argument
applied to it, it would return a function that expected the next argument.

## $\alpha$-conversion, $\beta$-reduction

These terms do absolutely nothing to dispell the feeling that the lambda
calculus is a bit elitist. Look, even more Greek letters - it must be
complicated and clever because just writing about it requires me to know how to
say $\alpha$!

Really though, these are just big words for 'substitution' and 'application',
the basics of which you probably picked up in high school algebra.

'α-conversion' (alpha-conversion) just means that we can change the name of a
bound variable in a Lambda expression. So if we've got:


$$ \lambda xy.x + y $$


We can just change all the $x$s to $a$s


$$ \lambda ay.a + y $$


And the expression hasn't changed its meaning one iota.[^2]

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

$$ (\lambda xy. x + y)\ 5 $$

Becomes

$$ \lambda y. 5 + y $$

(I threw some parentheses around that other Lambda expression to make it clear
that the $5$ was getting applied to the whole function and to separate it from
the body $x + y$ - there's no hard and fast rules as far as that goes).

Next up - [numbers made of functions][lambda-2]. Wait, what?

[^1]: To save on the world's dwindling supply of $\lambda$s
[^2]: Greek alphabet pun. BOOM!

[currying]: {% post_url 2015-02-19-not-quite-js-currying %}
[lambda-2]: {% post_url 2017-09-13-church-numbers %}

---
layout: post
title: "Lambda Calculus 3 - Arithmetic with Church Numbers"
date: 2017-09-23 20:54:21
tags:
    - Mathematics
    - Functional Programming
    - Lambda Calculus
published: true
---

Previously I've posted about [the lambda calculus][lambda-1]
and [Church numbers][lambda-2]. We'd shown how we can encode numbers as
functions using the Church encoding, but we'd not really shown how we could _do_
anything with those numbers.

But before we get into it, let's clear up some stuff about brackets...

## Left association and you

Just as it's easier to write $\lambda nfx.$ than $\lambda n.\lambda f.\lambda x.$
because we make the assumption that each application of the function returns
a new function, so there is a way of writing out function application without
having to use lots of parentheses.[^1]

Where we would normally write

$$
f(x)
$$

with parentheses, we could instead write

$$
f\ x
$$

under the assumption that each argument associates to the one on the left. So if
we had

$$
((f(x)\ y)\ z)
$$

we can write it as

$$
f\ x\ y\ z
$$

and something like

$$
(g(x)\ f(x))
$$

is

$$
g\ x\ (f\ x)
$$

As we still need the parentheses to make sure that the $f$ and $x$ get bundled
together. We'll need this convention as we go on as things are going to get a
little more parenthesis-heavy.

## Add-one

OK, let's get back to the arithmetic.

Say we have the number three:

$$
three \ \equiv \ \lambda f \lambda x.\ f\ (f\ (f x))
$$

(the function $f$ applied to $x$ three times)

And we wanted to get to the number four:

$$
four \ \equiv \ \lambda f \lambda x.\ f\ (f \(f\ (f x)))
$$

(the function $f$ applied to $x$ four times)

How do we get from $three$ to $four$? Well, the difference is that we just need
to apply $f$ one more time.

$$
four \ \equiv \ f\ three
$$

We can encode the idea of applying $f$ one more time into a lambda function. We
could call it $add-one$ or $increment$ but lets go with $succ$ for 'successor'.

$$
succ \ \equiv \ \lambda n. \lambda f. \lambda x.\ f\ (n\ f\ x)
$$

The $n$ is the number we're adding one to - we need to bind in the values of $f$
and $x$ in to the function because they'll need to have $n$ applied to them
before we can apply $f$ in the one extra time.

Another way to think of this is that the general signature for a number is
$\lambda f. \lambda x.$, and that when we apply $succ$ to a number, we need to
get back another number - something else with the signature of $\lambda f. \lambda\ x.$

So the signature of $succ$ - and consequently any unary operation on a
number - is $\lambda n.\lambda f.\lambda x$, where $n$ is the number being changed.

In Clojure that looks like:

```clojure
(fn [n] (fn [f] (fn [x] (f ((n f) x))))))
```

Yeah, it's a bit _verbose_ in comparison to the lambda calculus version.[^2] All
those parentheses, while great for being explicit about which functions get
applied to what, makes it a bit tough on the eyes.

What about Haskell?

```haskell
\n f x -> f (n f x)
```

Bit more like the original, eh? Haskell has currying and left-association baked
in to its syntax so its lambda expressions look almost exactly the same as the
lambda calculus ones. You can see why it's so popular.[^3]

## Addition

Let's see if we can define addition.

First off, $addition$ is an operation that takes two arguments, two numbers. So
we know it needs to look something like:

$$
\lambda m. \lambda n. \lambda f. \lambda x.
$$

Where $m$ and $n$ are the numbers being added together. Now all we need to do is
work out what comes after the dot.

We could define it in terms of $succ$ - all we need to do is apply $succ$
$m$ many times to $n$:

$$
\lambda m.\lambda n.\lambda f.\lambda x.\ m\ succ\ n\ f\ x
$$

And this works,[^5] but we could probably write something both more intuitive
and simpler.

What do we want as the result of $add$? We want a function that applies $f$ to
$x$ $n$ many times, and the applies $f$ to the result of that $m$ many times.

$$
add\ (\lambda fx.\ f\ (f\ x))\ (\lambda fx.\ f\ (f\ (f\ x))) = \lambda fx.\ f\ (f\ (f\ (f\ (f\ x))))
$$

We can just write that out with the variables we've been given - first apply $f$
to $x$, $n$ many times.

$$
n\ f\ x
$$

and then apply $f$ to that result $m$ many times

$$
m\ f\ (n\ f\ x)
$$

giving us

$$
add\ \equiv\ \lambda n.\lambda m.\lambda f.\lambda x.\ m\ f\ (n\ f\ x)
$$

The order of $n$ and $m$ doesn't matter as they're just the order in which the
number of $f$s are applied.[^6]

## Multiplication

We've used the word 'times' a lot here when talking about the application of $f$
onto $x$s in the above. But now we'll have to deal with real multiplication.

Before you try and reach at an answer, step back a little and ask yourself what
the result ought to be, and what the Church arithmetic way of describing it would
be.

Say we had the numbers two and three. If I was back in primary school I'd say
that the reason that multiplying them together made six was because six was 'two
lots of three' or 'three lots of two'.

So when I want to put this into Church arithmetic, I feel like saying 'six is
the application of three lots of the application of two lots of the application
of $f$ onto $x$'. Which is a mouthful, for sure, but looks like

$$
six\ \equiv\ \lambda f.\lambda x.\ ((three\ (two\ f))\ x)
$$

or, without the parentheses

$$
six\ \equiv\ \lambda f.\lambda x.\ three\ (two\ f)\ x
$$

$two\ f$ is a function that applies $f$ two times to whatever it's next argument
is. $three\ (two\ f)$ will apply $two\ f$ to its next argument three times. So it
will apply it $3\ \times\ 2$ times - 6 times.

And so now we can move from the particular case to the general case;
multiplication is:

$$
mult\ \equiv\ \lambda m.\lambda n.\lambda f.\lambda x.\ m\ (n\ f)\ x
$$

"$m$ lots of ($n$ lots of $f$) applied to $x$", which is still a mouthful but

## Exponentiation

So what could exponentiation be? Well, the first thing we know is that this
time, order _is_ going to be important - $2^3$ is not the same as $3^2$.

Next, what does exponentiation _mean_? I mean, really mean? When we did
multiplication we saw us doing 'two lots of (three lots of $f$)'. But now we
need to do 'two lots of something' three times. The 'three' part has to apply,
not to the number of times we do an $f$, nor the number of times we do '$n$ lots
of $f$'. But rather it needs to be _the number of times we do $n$ to itself_.

Woah.

So if 'three' is the application of $f$ three times to $x$, we can say that
$2^3$ is the application of $two$ three times to $f\ x$.

Even. Bigger. Woah.

Another way to look at it: a Church number is already encoding some of the
behaviour of exponentiation. When we use `inc` and `0` as `f` and `x` we can
think of the number `n` acting as $inc^n$ - `inc` done to itself `n` many times.

This is more explicit if we try it with something other than increment - say
`double`, aka 'times two'. Let's do it in Haskell - but please feel free to pick
any language you like.

```haskell
let timesTwo = \x -> 2 * x
let four = \f x -> f(f(f(f x)))

four timesTwo 1 -- 16
```

Four lots of `timesTwo` is 16; all we need to do is to use the number two
instead, and apply the result to an `f` and an `x`.

```haskell
let two = \f x -> f(f x)
four two succ 0 -- 16
```

Sixteen again.

So function for exponentiation - `m` to the power of `n` - is:

$$
exp\ \equiv\ \lambda m.\lambda n.\lambda f.\lambda x.\ n\ m\ f\ x
$$

But remember $\eta$-reduction? We can just go directly to:

$$
exp\ \equiv\ \lambda m.\lambda n.\ n\ m
$$

This is because you know the function you're left with after you've applied $n$
to $m$ is a number - will take an $f$ and an $x$ - you don't need to explicitly
bind them in the outer function just in order to pass them unchanged to the
inner one.

But that's just a nicety. The important thing is... we've finished!

## Summary and Next!

This post looked at some simple arithmetic using Church numerals. We saw successor

$$
succ\quad \equiv\quad \lambda n.\lambda f.\lambda x.\ f\ (n\ f\ x)
$$

addition:

$$
add\quad \equiv\quad \lambda m.\lambda n.\lambda f.\lambda x.\ m\ f\ (n\ f\ x)
$$

multiplication:

$$
mult\quad \equiv\quad \lambda m.\lambda n.\lambda f.\lambda x.\ m\ (n\ f)\ x
$$

and exponentiation:

$$
exp\quad \equiv\quad \lambda m.\lambda n.\ m\ n
$$

An interesting relationship between the last three: the $f$ moves along to the
right as the operation becomes 'bigger'.

Next post we'll be taking a short break from arithmetic to take a look at logic
using the lambda calculus.

[^1]: And I'm speaking as a mad Lisp fan, lover of parens where ever they are.
[^2]: But still terse compared to the mess we'd get in Python. Or Ruby. Yeah, don't try it in Ruby. Oh, and I guess we could use the short hand anonymous
    function syntax, but I think that'd look even messier...
[^3]: For functional programming that is.
[^5]: Get your pencil and paper out if you want to prove it!
[^6]: The same will go for multiplication. We know that this has to be the case if we're representing these numbers and operations correctly as they should display the [commutative property][comm]

[lambda-1]: {% post_url 2017-09-11-lambda-calculus %}
[lambda-2]: {% post_url 2017-09-13-church-numbers %}
[comm]: https:$/en.wikipedia.org/wiki/Commutative_property

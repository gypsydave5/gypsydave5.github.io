---
title: "dc"
published: false
date: 2019-06-05 20:33:31
description: The hidden pleasures of the Unix desk calculator
tags:
  - unix
  - maths
---

Maybe this story is familiar to you: you're working away, hotshot terminal user
that you are. You're a pretty fast typist - not the _fastest_ for sure, but
you're confident. Confident... but not always super accurate.

So you're hacking away, moving in and out of directories with `cd` (and then
immediately typing `ls` because that's what you do), except this time you slip
and instead of typing `cd` you somehow typed `dc`.

And then this happens:


```shell
$ dc

```

Nothing. Absolutely nothing. Now the faint of heart would, at this point, give
up. Perhaps a quick `^C` and the problem goes away.

But we are made of bolder stuff! Let me assure you that you've struck _gold_!
Ancient wisdom, layed down by the wise Unix masters for us to find. `dc` holds
many secrets, it comes from a noble heritage, and it has much to teach us. Come!
come with me friends! Let us explore the wonders of `dc`.

But first...

... what is it?

## `dc`, your friendly neighbourhood Reverse Polish Desk Calculator

`dc` is a _desk calculator_, as opposed to a _pocket_ calculator or a computer.
In fact, when `dc` was first written there really weren't any pocket
calculators: it was 1969.

(At this point feel free to cosplay a little to get you in the mood. Wear an
afghan coat, put some flowers in your hair, listen to Jefferson Airplane, drop
a little acid or stare at a mandala, whatever, man...)

So it's a desk calculator. So I can do sums with it, right?

```shell
$ dc
2 + 3
dc: stack empty
```

eh?

`dc` is a _reverse polish_ desk calculator; it uses Reverse Polish Notation
(RPN). What's Reverse Polish Notation you ask? Well, it's like Polish Notation
only backwards.

Sorry, sorry - it's an easy joke to make, which is why I did.

Polish Notation is also known as _prefix notation_. Instead of all the
mathematical operations appearing in between the numbers (`2 + 3`), in Polish
notation they appear at the beginning (`+ 2 3`).

The genius of Polish notation is that _it doesn't require parentheses or
operator prescedence_  to organise an expression.[^1] Let me demonstrate: take
the sum (in infix notation), `2 * (3 + 5)`. We know the answer to be `16`. But
if we shift the parentheses `(2 * 3) + 5` we get `11` instead. To make the
expression unambiguous we need the parentheses to show which numbers belong to
which operator.

But in Polish Notation we can do the same without the parentheses. The first
expression becomes `* 2 + 3 5`; the second `+ * 2 3 5`.

Seems a bit funny, doesn't it? The way to think of it is that, everytime you
introduce a new operator like `+` or `*`, you start waiting for enough nubers to
arrive on the right hand side for the operator to be applied.

For the first sum we start with `*`, we then get a `2` - so whatever comes next
is going to get multiplied by `2`. But what's next is a `+` - so now we have to
wait for the `+` to get enough numbers given to it for it to become a number.
Happily we get a `3` and a `5`, so the `+` turns out to be a `8`, which we can
then immediately multiply by `2`.

So that's Polish Notation - think of each operator as 'waiting around' for
enough input from the right to do something.

Reverse Polish Notation works in exactly the same way, only backwards. This is
what our two sums would look like in RPN: `2 3 5 + *` (which evaluates to `16`), and `2 3 * 5 +` (which evaluates to `11`).

Instead of each operator waiting for new things on the right, they 'eat up'
things that have already appeared on the left. Looking at the first sum again,
we 'serve up' a `2`, then a `3`, then a `5`. Then a `+` appears; it eats the two
numbers closest to it on the left - the `3` and `5` - and becomes an `8`. Then
the `*` appears at the end. It also eats the two numbers closest to it on the
left - which are now a `2` and the new `8`, and spits out the answer, `16`.





[^1]: Ironically, the most popular family of programming languages that uses
  Polish Notation is Lisp, _which is full of parentheses_.
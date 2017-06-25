---
layout: post
title: "Modularity is its own reward"
date: 2017-06-24 12:44:27
tags:
    - TDD
    - Design
    - Modularity
published: false
---

A while back an friend and I were talking about programming. They'd recently taken
it up in the job he was doing and were relatively fresh to the discipline.
Asking for a code review from a collegue, they'd been told that their Python was
pretty good but that it could do with breaking out into smaller functions.

My friend couldn't see the point of this - the code worked, it did the job,
what's the problem? I had a crack at explaining why. Didn't do very well.

More recently I was getting some feedback for something small I'd written.
It was, of course, awesome - like all the code I write.[^1] They said they
liked it, but the modularity wasn't entirely necessary because the individual
modular parts wouldn't be reused.

So this is just a scratch piece to try to explain why I think modularity is the
most imortant thing

Oh and the title is an homage to my favourite xkcd comic:

![tail recursion is its own reward](https://imgs.xkcd.com/comics/functional.png)

## Wait, modularity?

When I say 'modular', I mean small and isolated and independent. A class that's
a few lines long, the one line method in Ruby, the short function. At a larger
level I mean, well, larger small things. A file with one class in it, or one
function in it.  Maybe I mean microservices. Maybe not.

Look, I mean small things. That's all. But why do I think that they're their own
reward? Well, I don't[^2] - but I think that, most of the time, more good things
come out of keeping the code smaller than larger. Such as...

## Easier to Test

What sort of tests do you love? When there are hundreds of them - which ones
make you happy inside? In my (admittedly limited) experience, it tends to be the
ones that run really quickly and don't randomly fail. Sure, the ones that
exercise the whole system are nice and necessary, but the ones that make me
smirk a little are the unit tests that whizz by in the blink of an eye.

And in order to have those fast little tests, you need small little bits of code
to test.

TDD makes us write the tests first - and the easiest tests to write are the ones
that cover single, simple ideas that you want to implement. TDD wants us to
write small tests that consequently should lead us to write small pieces of
code.

Performing TDD produces code with tests - this is a given. But I find that
people celebrate this more that what I think the bigger prize is: you have been
forced into writing your code modularly, bringing with it other and possibly
greater advantages.

## Easier to Comprehend

This is probably the most important one. If your code is small and independent,
then there is a much higher chance of you and everyone else understanding what
it does. If a single function / class / method is longer than a screen, I would
go so far as to say that it's near impossible to understand what it does. Some
clever people[^3] think that understanding small pieces of code is more important
than TDD - maybe. But it's definitely not inconsequential.

If you're programming in small, easy to comprehend[^4] parts, then there is more
chance that you'll be understood - if only because you'll have had to give them
names. Possibly bad names, but names all the same. Names you'll be able to read
and know what they mean and so what the parts do. Or at the worst, names that you
read, don't understand, and then read the code, understand that because it's
short, and then rename it with something (hopefully) better.

## Easier to Reuse

Yes, reuse is good - it's a good benefit of small pieces of code. You write that
Fibonacci function, you can use it everywhere that you need a Fibonacci number.
It is part of the wonderful magic of small, independent things.

Whether you do reuse a part of code is often by the by - it can often come later
on when you have a better idea about the thing that you're trying to build.

## This all sounds familiar...

Look, if you've heard this before then you probably have - hell, I just worked
out what I was talking about when I got to the end of writing it. It's basically
the first two bulletpoints of the [Unix philosophy][UnixPhil] - do one thing
well, and integrate with other programs.

But as we're not writing programs - we're just writing parts of programs - we
don't have to worry about the requirement for generalization (that can come
later if at all). And integration is eased if we make the modules truely
independent of each other.

[^1]: For 'awesome' read 'adequate'.
[^2]: Barely anything is its own reward. Maybe pizza.
[^3]: Rich Hickey's classic "We say, “I can make a change because I have tests.” Who does that? Who drives their car around banging into the guard rails!?".
[^4]: From the Latin _com_ together, and _prehendere_ grasp.

[UnixPhil]: https://en.wikipedia.org/wiki/Unix_philosophy


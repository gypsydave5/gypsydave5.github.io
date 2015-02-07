---
layout: post
title: "Three Ways with Clojure"
date: 2014-12-21 21:04:07
tags:
    - Clojure
    - Functional Programming
published: true
---

I've been working with [Clojure] in the last few days, both looking at the
[Clojure Koans] and another resource I've discovered [4clojure.com]. I'd like to
share a nice problem I saw there, and some of the solutions to it which I think
expose some of the things I'm beginning to appreciate about the language.

###The Problem

as stated on [4clojure](http://www.4clojure.com/problem/21#prob-title).

>Write a function which returns the Nth element from a sequence.
>(Without using `nth`)

`nth` is the obvious answer to the problem, as it returns the nth element in
a sequence:

```clojure
(= 2 (nth 1 '(1 2 3 4)))
```


We need to get to a function that will do the same, something that will fit
in the blank space below:

```clojure
(= (___ '(4 5 6 7) 2) 6)
```

###Solution 1: recurring

```clojure
(fn my_nth [seqn n] (if
    (zero? n)
    (first seqn)
    (my-nth (rest seqn) (dec n))))
```

Here we use recurrance, setting the breaking point as the iteration where `n` is
zero using `if`, at which point the function returns the `first` value of the
sequence. If it's not, we fire the function again, but this time chopping off
the first member of the sequence (`(rest seqn)` returns the rest) and
`dec`rementing the value of `n` by one. We walk through the sequence, losing
items from the front of the sequence `n` times, until we get to the index.

We've named the function `my_nth`, but we could easily anonymize it:

```clojure
(fn [seqn n] (if
    (zero? n)
    (first seqn)
    (recur (rest seqn) (dec n))))
```

`recur` is neat - it executes the expressions that follow it, then rebinds the
values hey produce to the bindings of the recursion point, in this case the
`fn` method. We then get moved back to that method with the new values, causing
the recusion. Very cool.

Usually recursion is a neat way of writing a short function; here it's pretty
longwinded. We can get smaller...

###Solution 2: taking

```clojure
(fn [seqn n] (last (take (inc n) seqn)))
```

Here we `take` the first one-more-than-n (`inc` increments its argument) items
from the sequence, and then take the `last` one from the end of that new list-
which will be the nth element.

`take` is used in many of the examples I've seen as a way of accessing
a sequence which may be infinite like the Fibonacci series - see some of the
examples over at
[Wikibooks](https://en.wikibooks.org/wiki/Clojure_Programming/Examples/Lazy_Fibonacci).

We can squeeze more succinctness in there using some alternative syntax:

```clojure
#(last (take (inc %2) %1))
```

But if you want to be really succinct:

###Solution 3: ripping off Java

```clojure
.get
```

Clojure gives you access to Java methods and fields through the use of the dot
(`.`) operator, which taks the form `(.instanceMember instance arguments*)`.
Here we're using the `get()` method from the Java [Lists
interface](http://docs.oracle.com/javase/tutorial/collections/interfaces/list.html),
which we get to use on these instances as they are, well, Java lists.  which
takes one argument - and luckily for us its the index! We're calling `get(6)`
on the list, which gives us the answer we want.

This is pretty close to cheating, but it goes to show how Clojure's access to
Java gives us a whole other language of libraries and methods to play with.

[Clojure]: http://clojure.org/
[Clojure Koans]: http://clojurekoans.com/
[4clojure.com]: http://www.4clojure.com/


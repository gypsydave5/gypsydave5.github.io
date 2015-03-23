---
layout: post
title: "Lazy Evaluation and Memoization"
date: 2015-03-21 21:41:18
tags:
    - JavaScript
    - Mergermarket
    - Learnings
    - Functional Programming
published: false
---

I've been seeking out more functional JavaScript ideas since I started to get
addicted from my exposure to [the `bind()` function]. My next 'conquest' has
been **lazy evaluation**.

Calculations take time and resources. For instance, if I needed to know what
`4719340 + 397394` was (and I didn't have a calculator), it would take a few
minutes to work out. Right now as I'm typing this, I don't need to know.
Maybe I'll never need to know. I could put those two numbers and the `+` sign on
a piece of paper, stick it in my pocket and, if ever I needed or was
curious/bored enough to know the answer, I could get the paper out. I could
write 'Answer to silly blog sum' on the top of the paper so I could know what
the paper is for.

That's lazy evaluation - hold on to an expression and only evaluate it when you
need to use it. It pairs with **memoization** - keeping the results of evaluated
expressions handy so that you don't have to evaluate them everytime you need
their result.

(Which figures as, if I ever do work out what `4719340 + 397394` is, I never
want to work it out again.)

So let's take a look at a piece of lazy evaluation in JavaScript. Say we have
a simple function:

```javascript
function add (a, b) {
  return a + b;
}
```

And we'd like to make that function lazy - with another function, naturally.
Something like:

```javascript
var addThisLater = lazyEval( add, 4, 5 );

addThisLater() //=> 9
```

`lazyEval()` takes a function name, some more arguments, and returns a function
that, when it evaluates, returns the result of evaluating the passed in function
with the other arguments.

So far so good - but what needs to go inside `addThisLater()` to make it work as
we describe it above? As it turns out, not that much:

```javascript
function lazyEval (fn) {
  return fn.bind.apply(fn, arguments);
}
```

And this is where things get exciting. We've [seen `bind()` before], so let's
take a look at `apply()`, what happens when we chain it with `bind()`, and
what's happening with `arguments`.

[`apply()`] is pretty simple - it's a method of a function that, when evaluated,
returns the result of evaluating the function with the scope of the first
argument (just like `bind()`). The second argument is an array (or an array-like
object) of arguments to evaluate the the function with. Which all sounds scary,
but if I do this:

```javascript
add.apply(this, [ 1, 2 ]) //=> 3
```

I hope that makes more sense.

[`arguments`] is an array-like object (and you can just read about what exactly that
means yourself) which contains, unsurprisingly, all of the arguments
passed to the current function you're in. In the above example, when `apply(fn,
arguments)` is evaluated, its passing the arguments `fn, 4, 5` along to the
function `apply()` is being called on. Namely, in this case, `bind()`.

(As a counter example, if `apply()` was replaced by it's close cousin, [`call()`],
which takes more traditional looking arguments, it would look like this:
`bind.call(fn, fn, 4, 5)`)

`fn, 4, 5` gets passed along to `bind()`, where `fn` becomes the `this`
argument, providing the scope, and the `4, 5` get bound to the arguments of the
function that `bind()` is being called on (in our examples, `add()`). And so we
get the add function back with all its arguments bound, ready to be evaluated
with a flick of our `()`.

### Memoization ###

All of which is great, but what's the point if you evaluate the function
everytime it's called? Wouldn't it be better if the function 'remembered' the
result, and returned the remembered result the second time it was called rather
than evaluating it all over again? Or, to continue the increasingly strained
example, I should write the answer down on my piece of paper once I've worked it
out, rather than having to do the sum every time I need to know the answer.

And that's [memoization], a way of optimizing code so that it will return cached
results for the same inputs. This might get a little more complicated with
functions that have more than one input, but for our little `lazyEval` function
it's not all that hard (there's no arguments at all!):

```javascript
function lazyEvalMemo (fn) {
  var args = arguments;
  return function () {
    var result;
    var lazyEval = fn.bind.apply(fn, args);
      return function () {
      if (result) {
        console.log("I remember this one!");
        return result
      }
      console.log("Let me work this out for the first time...");
      result = lazyEval()
      return result;
    }
  }()
}
```

Let's give it a function - a `sum` that does a little reporting for us...

```javascript
function sum (a, b) {
  console.log("I'm calculating!");
  return a + b;
}
```

And let it rip!

```javascript
var lazyMemoSum = lazyEvalMemo(sum, 4719340, 397394)

lazyMemoSum()
// => Let me work this out for the first time...
// => I'm calculating!
// => 5116734

lazyMemoSum()
// => I remember this one!
// 5116734
```

It does the calculation the first time, and every subsequent call uses the
memoized result.

[the `bind()` function]:
[`apply()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply
[`arguments`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments
[`call()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call
[memoization]: https://en.wikipedia.org/wiki/Memoization
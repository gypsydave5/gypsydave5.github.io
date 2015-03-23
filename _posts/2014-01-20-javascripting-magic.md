---
layout: post
title: "(not quite) Currying in JavaScript"
date: 2015-02-01 16:25:18
tags:
    - JavaScript
    - Mergermarket
    - Learnings
    - Functional Programming
published: false
---

Currying, yet another computer science term I'm all at sea with. Acually,
having done some reading, it turns out the cool kids may be misusing it, but
we'll get to that part later. Let's just spend a minute looking at the wonder of
`.bind()`.

Here's a function:

```javascript
function addition(a, b) {
    return a + b
}

addition(1, 2) //=> 3
```

Let's say we always wanted to be adding twenty-two - we could make ourselves
a shiny new function, or we could build on the way `addition` works using
`.bind()`

```javascript
var addTwentyTwo = addition.bind(this, 22)
addTwentyTwo(1) //=> 23
```

`bind()`, as you'll see in the [MDN docs], is a method you can call on a function in
JavaScript. It creates a new function based on the old one, with the `this`
keyword of the new function set to the first argument to `bind()`, and other
arguments given being set to the arguments of the original function. Confusing,
right? Well, it's probably best to ignore the first arpument, the `this`
reassignment for now, unless there's a pressing need to change it, and focus on
the rest. Here, let's do it again:

```javascript
var twentyFive = addTwentyTwo.bind(this, 3)
twentyFive() //=> 25
```

When we use `.bind()` we can change the _arity_ (number of ardguments) of the
function returned, setting the values of any of all of the arguments in the
original function:

```javascript
var twoHundred = addition.bind(this, 50, 150)
twoHundred() //=> 200
```

What bind allows us to do is _partial application_, fixing values of a function
and returning one of smaller arity:

```javascript
function addTheseFourUp(a, b, c, d) {
  return a + b + c + d
}

var addTwoAndTheseThreeUp = addTheseFourUp(this, 2)

addTwoAndTheseThreeUp(1, 2, 3) //=> 8
```

This is technically not _currying_, which should only return functions with an
arity of 1. Currying `addTheseFourUp` would look something like this:

```javascript
function curriedFour(a) {
  return function(b) {
    return function(c) {
      return function (d) {
        return a + b + c + d
      }
    }
  }
}

curriedFour(1)(2)(3)(4) //=> 10
  ```

[MDN docs]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind

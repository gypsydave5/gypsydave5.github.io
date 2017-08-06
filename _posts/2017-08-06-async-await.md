---
layout: post
title: "async/await in JavaScript in Five Minutes"
date: 2017-08-06 18:53:32
tags:
    - JavaScript
published: true
---

When I first heard about async/await in JavaScript I was quite excited. Now
I know about it I'm not. Let me explain; instead of doing some Lisp this evening
I decided to find out what async/await fuss was about, and I think I can put it
in a single sentence.

> async/await is syntactic sugar to make Promises look more sequential

That's it. If you have the most basic understanding of Promises in JavaScript
then you should be able to use async/await in about thirty seconds. There is
nothing surprising here, which is a relief.

### async

Think of this as an annotation to a function - a way of saying that, within this
lexically scoped block, we'll be living in async/await world.

```javascript
async function asyncAwaitLand () {
 // blah blah fishcakes
}
```

### await

In async/await world, `.then()` is spelt `await`. And it's another annotation,
this time to to an expression. What larks. Here it is in Promise-speak:

```javascript
function normalPromiseLand () {
    Promise.resolve('some value')
        .then(theResultOfAPromise => console.log(theResultOfAPromise))
}

```

And here's the same thing in ~nuspeak~ async/await
```javascript
async function asyncAwaitLand () {
 const theResultOfAPromise = await Promise.resolve('some value')
 console.log(theResultOfAPromise)
}
```

### Interop with Promises

I say 'interop' but that's crap: `async` functions _return_ Promises anyway, so
if you want to start chaining them all together be my guest:

```javascript
const arrowAsync = async () => {
    return 'the async annotation works with anonymous arrow functions too'
}

arrowAsync()
    .then(string => console.log(string))
```

### Errors and Rejects

But how do you `.catch()` those long-`await`ed Promises when they go horribly
wrong?  Would it surprise you at all if I told you that you just use the normal
sequential JavaScript error handling construct of `try/catch`?

```javascript
function rejectedPromise () {
    return Promise.reject(new Error('boom'))
}

async function asyncAwaitLand () {
    try {
        const nope = await rejectedPromise()
        console.log('will never happen', nope)
    } catch (error) {
        console.log('I caught a rejected Promise:', error.message)
    }
}
```

So how do you `reject()` in an `async` function? You can guess right? You just
`throw` like it's sequential code.

```javascript
async function throwingAsync () {
    throw new Error('boom')
}

function promiseLand () {
    throwingAsync()
        .then(nope => console.log('will never happen', nope))
        .catch(error => console.log('I caught an async throw:', error.message))
}

```

### Are you still reading this?

async/await is _boring_ - thank goodness. A pretty piece of syntactic sugaring
that extends the language not one jot.  If you understand Promises then you
should already have some ideas for how you're going to use it - more of a way of
tidying up some ugly looking bits of code than a complete rethink of your
codebase.

If you don't understand Promises - stop reading articles about async/await and
start reading articles about Promises.

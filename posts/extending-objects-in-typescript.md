---
layout: post
title: "Extending Somebody Else's Object in TypeScript"
date: 2022-01-24 19:12:28
tags:
    - TypeScript
published: true
---

Here's how to extend ("monkey patch") a JavaScript class in TypeScript, without giving up on type safety (or our precious auto complete).

## Our example: `tape`

[Tape][tape] is a gloriously simple testing harness for JavaScript. I'd use it more often but the Webstorm support is non-existant, and I use Webstorm at work, and, well... anyway, it's great, take a look at it.

Our example is going to involve extending the testing object of `tape` with a "custom matcher": a way of wrapping a bit of testing logic up into a reusable method. In `tape`, the test assertions are all methods on an instance of `Test`, which is passed into each test. Like this:

```typescript
import test from 'tape';

import test, { Test } from 'tape';

test('2 divided by 2 is 1', function (t: Test) {
    t.equal(2 / 2, 1)
    t.end()
});

```

Pretty bare-bones, but easy to understand. What I'd like is something that looks more like this:

```typescript
import test from 'tape';

import test, { Test } from 'tape';

test('2 divided by 2 is 1', function (t: Test) {
    t.isOne(2 / 2)
    t.end()
});

```

## First step: how to extend a class in JS

This is, if anything, the easy bit. We get hold of the `Test` class and fiddle with its prototype. By 'fiddle' I mean go and add a new method to it. Some developers (mainly Java developers) don't like this jiggery pokery and sneeringly call it "monkey patching". I think it's _fine_ if you're not trying to share the code as a library, and it's _definitely fine_ when it's in your test code. Maybe take a look at how Smalltalk does the same thing a lot without any pearl clutching. Or Perl clutching. But I digress. Here's an extension in plain old JavaScript, using NodeJS and CommonJS modules:

```javascript
const test = require('tape')

test.Test.prototype.isOne = function isOne(number, message) {
  this._assert(n === 1, {
    message: message || `${number} equal to 1`,
    operator: 'isOne',
    actual: n,
  });
};

```

Word of explanation: the `_assert` method is a private method within the `Test` instance. Yes, we're depending on a private API. Yes, that should worry you a little bit. But, like I say, it's in the tests and they're _my_ damn tests so I'll do as I please thank you.

If this whole `prototype` thing is all a bit of a mystery to you, I gently suggest that you take a look over at [_You Don't Know JS_](https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/README.md), and read the book about Object Prototypes. Anyway, drop that in your code where you like and, as if by magic, you'll be able to run the example above.

However, you won't be able to _compile_ the example as TypeScript still doesn't know about the method. It is still going to be using the type definitions from `@types/tape`, which definitely don't include `.isOne()`. And we won't get the awesome completion in our IDE, which, as we all know, is the _real_ reason we love static typing so much. So how can we _gently re-educate_ TypeScript about our new method?

## Module Augmentation

We're going to do this through [_module augmentation_](https://www.typescriptlang.org/docs/handbook/declaration-merging.html#module-augmentation). Take a look at the docs, and if you do you'll probably abandon this whole blog post as it's mostly a re-hash of that. But, let's press on.

Mostly we tell TypeScript about the types in our systems through annotating our code. You know, saying that our variables are `string`s, or that this function takes a `number` and returns a `boolean` and the like.

We also create some types ourselves, built using other types. `interface`s and `type`s, and even `class`es are good examples of these.

But what we're going to do now is crack open an existing type and start adding to it. We'll keep it simple by having our type declarations all in the same file as the implementation - so the same file as the `test.Test.prototype` stuff in this case. What we'll do is, essentially, redeclare a module that we import in the code, and write a new declaration of one of its members which includes the new methods we're going to write. Like this:


We import the `'tape'` module, then immediately redeclare it. And then, inside the module declaration, we write a new `Test` class with the method definitions we want on it. Hurrah. Note that I decided to define the `_assert` method as, well, it just shuts up the typechecker when I'm writing the implementation. But also note that I did a _terrible_ job of it by using `any` all over the place. But it's fit for purpose, and saves me the pain of trying to work out the type of the private options object. Yuck.

So putting it all together in one file: 

```typescript
// inside `tapeExtensions/index.ts`
import test from 'tape';

declare module 'tape' {
  class Test {
    isOne(n: number, message?: string): void;
    _assert(ok: boolean, options: any): any;
  }
}

test.Test.prototype.isOne = function isOne(n: number, message?: string) {
  this._assert(n === 1, {
    message: message ||  `${number} equal to 1`,
    operator: 'isOne',
    actual: n,
  });
};
```

then we just import the `tapeExtensions` module. Note that we're not importing it to use anything exported by it; we're just doing it for the side-effect of extending `Test` with our new method. Yes, this might make you uncomfortable (_ooooh side effects BAAAAAD! Mokey patching BAAAAD! OH NO HE'S USING INHERITANCE QUICK GET THE CRUXIFIX!_), that's a larger conversation that I'll need to have with you one day. Anyway, here's how to use it:

```typescript
// in
import test, { Test } from 'tape';
import './tapeExtensions';

test('2 divided by 2 is 1', function (t: Test) {
    t.isOne(2 / 2)
    t.end()
});
```

So, there you are: all the awesome power, just itching to be abused, of writing extending an object using "monkey patching", combined with type safety. You could easily make a mess of all this if you don't use it with good taste and a bit of common sense, but we're all _professional software developers_ right? We know what we're doing, right?

[tape]: https://github.com/substack/tape

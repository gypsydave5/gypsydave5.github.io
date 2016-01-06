
---
layout: post
title: "(Even More) Memoization and Lazy Evaluation in JavaScript"
date: 2015-11-17 20:08:44
tags:
    - JavaScript
    - Mergermarket
    - Learnings
    - Functional Programming
published: false
---

A while ago I wrote a piece on [basic lazy evaluation and memoization in
JavaScript][firstBlog]. I'd like to continue some of the thoughts there on
memoization, and also show how to do the same thing but without all the
implementation details using some popular functional libraries.

### Memoization refresher

So the first time we saw memoization it was in the context of [lazy
evaluation][firstBlog], where the memoized function had already been 'prepped'
to be lazy. The lazily evaluated function was executed within our memoizer, and
the result was retained within the scope of the memoized function, to be
returned each subsequent time the function was called. As a refresher:

```javascript
function lazyEvalMemo (fn) {
  var args = arguments;
  var result;
  var lazyEval = fn.bind.apply(fn, args);
  return function () {
    if (result) {
      return result
    }
    result = lazyEval()
    return result;
  }
}
```

Which is great if want the function to be memoized with a specific set of
arguments. But that isn't going to work all of the time - probably not even most
of the time. It's rare that there's just one set of parameters we want to be
eternally bound to our function. A bit of freedom would be nice.

### Keeping track of your arguments







[firstBlog]: {% post_url 2015-03-21-lazy-eval-and-memo.md %}

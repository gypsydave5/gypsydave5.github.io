---
title: Default Parameters Considered Harmful
description: An overused feature that can royally mess up your code
published: false
date: 2025-02-19 22:52:55
tags:
  - language
---

## What is it good for?

### Intermediate step in a refactoring

Kent has a nice bit about it in his new book, pointing out how you can use a default parameter to change the parameter list of a function.

### Public APIs

Whether an SDK or a JSON web API, if there are too many options to set it's a pain to let the user have to set them all. 99% of usecases will probably only use one of them anyway. Yes, there'll be some pain sometimes, but often this will happen early in their use of the library, when they're motivated to read the documentation, which will be plentiful and well written as it's very public API.

Note that in a public API, the 'production' use of the 'function' in question is far more frequent than the test use. So the default naturally gravitates towards a sensible value _for production_.


## Considered harmful

### Defaults for test code

My all-time least favourite. 
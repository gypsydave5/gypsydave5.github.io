---
layout: post
title: "Arrays in JavaScript"
date: 2015-02-14 22:40:30
tags:
    - JavaScript
    - Learnings
published: true
---

Arrays are easy, right? Pretty basic go-to data structure. Pretty primative. So
if we did something like this - we wouldn't be messing with the array would we?

```javascript
array = ["tom", "alan", "harry"]
array.suprise = "dave"
```

surely not?

```javascript
for (index in array) { console.log(index) }

//=> 0
//=> 1
//=> 2
//=> surprise

console.log(array)
//=> ["tom", "alan", "harry", suprise: "dave"]
```

Which might just be a good reason not to use `for... in`, or trusting it to put
things as strings in a sensible way, but is a good demonstration of...

```javascript
typeof bob
//=> "object"
```

Because everything is an object in JS, the interface for arrays is kinda hacked
together out of object properties. Arrays are built on top of
objects, they are not a simpler data-type, and objects in JS are just **collections of strings that point at things**.

(and there aren't just arrays to consider - when there's the world of
[Array-like objects] to look at. But more on that another time.)

[Array-like objects]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Predefined_Core_Objects#Working_with_Array-like_objects

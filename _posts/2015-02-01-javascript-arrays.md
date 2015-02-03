---
layout: post
title: "Arrays in JavaScript"
date: 2015-02-01 16:25:18
tags:
    - JavaScript
    - MergerMarket
    - Learnings
published: false
---

Arrays are easy, right? Pretty basic go-to data structure. Pretty primative. So
if we did something like this - we wouldn't be messing with the array would we?

```javascript
array = ["tom", "alan", "harry"]
array.suprise= "dave"
```

surely not?

```javascript
for (index in array) { console.log( index ) }

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

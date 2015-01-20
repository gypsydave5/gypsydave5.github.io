---
layout: post
title: "Things I never knew about JavaScript"
date: 2015-01-01 21:28:04
tags:
    - JavaScript
    - MergerMarket
published: false
---

Working at MergerMarket is fun. Not only am I getting to grips with a new
language, [Groovy], in a nice, agile environment, on a project that's is
challenging but that I can make some small and increasing contribution to. Not
only that, but I'm also working with some damn clever and patient people who
are happy to explain things to me as we go along.

So here's what I've learned about JavaScript in the last fortnight:

###Hoisting
At then top of my list of "words I'd heard associated with JS but didn't have
the foggiest", _hoisting_ or, more transparently, variable hoisting. Behold the
following:

```javascript
function printThis(showLog) {

    if(showLog === true){
        var logMessage = 'MESSAGE!';
        console.log(logMessage);
    }

    console.log(logMessage);
}
```

Which you may be inclined to think would return two outputs to the console when
called with `printThis(true)`, one of `MESSAGE!` and then the ubiquitous JS
`undefined`. Of course it doesn't, what you instead get is:

```
MESSAGE!
MESSAGE!
```

because the interpreter looks at the code and does this to it:

```javascript
function a(showLog) {

    var logMessage;

    if(showLog === true){
        logMessage = 'MESSAGE!';
        console.log(logMessage);
    }

    console.log(logMessage);
}
```

The variable is 'hoisted' out of its declaration in the block and created at the
top of the function. The assignment still takes place in the same place, but
because the scope of `logMessage` is the entire function, the variable is still
available at the last `console.log`. This is because (maxim incoming) **JS only
has function-level scope, not block-level scope**. The interpreter just ignores
those little `{` and `}` unless they're backed up with a function declaration.

###You think that's an Array you're iterating over?

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

Which might just be a good reason not to use `for... in`, but is a good
demonstration of...

```javascript
typeof bob
//=> "object"
```

Because everything is an object in JS, the interface for arrays is kinda hacked
together out of object properties. Arrays are just complications on top of
objects, and objects in JS are **just strings that point at things**.





the var is hoisted to the top of its scope - and JS ony has function scope, that
if block is meaningless.

So we get functionally:

```javascript
function printThis(showLog) {

    console.log(logMessage);

    if(showLog === true){
        var logMessage = 'MESSAGE!';
        console.log(logMessage);
    }

    console.log(logMessage);

}
```

```javascript
function a(showLog) {

    var logMessage;
    console.log(logMessage);

    if(showLog === true){
        logMessage = 'MESSAGE!';
        console.log(logMessage);
    }

    console.log(logMessage);

}
```

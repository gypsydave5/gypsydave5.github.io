---
layout: post
title: "Hoisting in JavaScript"
date: 2015-02-01 16:25:18
tags:
    - JavaScript
    - MergerMarket
    - Learnings
published: true
---

Working at [Mergermarket] is fun. Not only am I getting to grips with a new
language, [Groovy], in a nice, agile environment, on a project that's
challenging but to which I can make some small and increasing contributions to. Not
only that, but I'm also working with some damn clever and patient people who
are happy to explain things to me as we go along.

So my next thsee posts will be about some of what I've learned about JavaScript
in the last month with Mat, Mike, Danielle, Nick and many others.

###Hoisting
At the top of my list of "words I'd heard associated with JS but didn't have
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
`undefined`. Because `logMessage` isn't defined at the second `console.log()`.

Does it?

```
MESSAGE!
MESSAGE!
```

Because the interpreter looks at the code and does this to it:

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
available at the last `console.log`. This is because (motto alert) **JS
has function-level scope, not block-level scope**. The interpreter just ignores
those little `{` and `}` unless they're backed up with a function declaration.

[Groovy]: http://groovy.codehaus.org/
[Mergermarket]: http://www.mergermarket.com/info/

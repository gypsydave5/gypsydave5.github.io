---
layout: post
title: toJSON and toString
description: Looking at two built in methods for transforming your JavaScript objects
published: true
tags:
    - TypeScript
date: 2021-12-08 15:04:05
---

## `toString`

What's everyone's favourite thing to see on the screen when writing TypeScript or JavaScript? The one message that lets you know you're winning?

```
[object Object]
```

Oh `[object Object]`, how we love you. So objecty they named you twice. But why, as my three year old daughter keeps saying. Why?

An example is worth a thousand words and so:

```javascript
{}.toString() // '[object Object]'
Object.prototype.toString() // '[object Object]'
```

`[object Object]` is the default output of the JavaScript `Object` prototype's `toString()` method, and that prototype is what every new object in JavaScript inherits from. Even if you think you've got no `toString()`s on you:

```javascript
const pinoccio = {
    strings: 0,
    isHeldDown: false,
    frets: 0,
    frowns: 0,
}

pinoccio // '[object Object]'
```

or even

```typescript
class Pinoccio {
    constructor(
        public readonly strings: number, 
        public readonly isHeldDown: boolean,
        public readonly frets: number,
        public readonly frowns: number,
        )
}

new Pinoccio(0, false, 0, 0) // '[object Object]'

```

How do we avoid this? Well we either

1. Never output `pinoccio` as a string
1. Change `Object.prototype.toString()` (don't do this)
1. Write our own way of turning `pinoccio` to a string
1. Override the `toString()` method

3 is not a bad idea, and it's what a lot of more "functional" developers do in JavaScript:

```typescript
function stringMyPinoccio(pinoccio: Pinoccio): string {
    return `I've got ${pinoccio.strings} strings, to hold me down`
}
```

But why bother, when you can just lean on a little old fashioned object oriented programming to make your life so much better...

```typescript
class Pinoccio {
    constructor(
        public readonly strings: number, 
        public readonly isHeldDown: boolean,
        public readonly frets: number,
        public readonly frowns: number,
        )
        
    toString(): string {
        return `I've got ${this.strings} strings, to hold me down`
    }
}

new Pinoccio(0, false, 0, 0) // 'I've got 0 strings, to hold me down'

```

The best thing about this approach is that now you'll get the appropriate string output for pinoccio whenever `toString()` is called. And it's called _everywhere_. Whenever an object should be a string in the opinion of JavaScript, then this is the method that will get called. So now if I want to stick `pinoccio` in a longer string:

```javascript
`Met a funny chap called Pinoccio who looks like: ${pinoccio}`
// '`Met a funny chap called Pinoccio who looks like: I've got 0 strings, to hold me down`
```

and what's really wonderful about this is that it's recursive. The call of `toString()` on `pinoccio` actually ends up calling `toString()` on the `strings` property of `pinoccio` - because it's being used in a string too...

If you manage to organize things well, you could get some really nice, informative and readable strings coming out of your program. Instead of `[object Object]`.

Of course, you could argue that you will _never_ need to see your object as a string. And I can admit, it might seem that way. But given that this is what you will see in your debugger, or in a console, or in your logs, it might be worth overriding `toString()` with something useful rather than useless.

On the subject of logs...

## `toJSON`

What's everyone's favourite log message?

```
'{"message":"service failed to do the thing","error":"{\\"message\\":\\"something went wrong with this request\\",\\"request\\":\\"{\\\\\\"headers\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"content-type\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"application/json\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"body\\\\\\":\\\\\\"{\\\\\\\\\\\\\\"message\\\\\\\\\\\\\\":\\\\\\\\\\\\\\"hello world\\\\\\\\\\\\\\"}\\\\\\",\\\\\\"method\\\\\\":\\\\\\"POST\\\\\\",\\\\\\"url\\\\\\":\\\\\\"http://hello\\\\\\"}\\"}"}'
```

Yes, that's right - it's nested JSON. Nothing like nested JSON to ruin your day, as you repeatedly paste and pares each individual bit to understand what the hell went wrong, or try to strip the forward-slashes using the power of your mind. No, that doesn't work.

Nested JSON messages are what happens when you just add a little bit extra on to an error message to give context, but decide that that context is probably an object like the request you just sent. And so you `JSON.stringify` that object into the error message string. But the that error message string winds up inside another object that, unknown to you, _also_ gets `JSON.stringify`'d, and etc and so on until you get to forward slash city.

What's tragic about all this is that we live in a world of _structured logging_ these days: we don't just log messages, we log whole damn bits of JSON so we can run exciting queries to tell us exactly how badly we've screwed up this time.

But getting a nice bit of JSON out of a JavaScript error can be a bit annoying. For instance, there's only really three fields on your basic `Error`: the `name`, the `message` and the `stack` trace.

Most browsers do a good job of showing all three in their console. And the `toString()` implementation in `Error` is actually pretty good:

```javascript
new Error('the badness').toString() // 'Error: the badness'
```

You get the name of the class and the message. Pretty useful. But have you seen what happens when you try and turn one of them into JSON?

```javascript
JSON.stringify(new Error('the badness')) // '{}'
```

How useless is that?

So how do we (1) get some more structure into our `Error`s, and (2) turn them into nice JSON?

### Custom errors

To customize our errors we should _subclass_ them. Yes, I know. Inheritance is the great Satan of object oriented programming. "Favor object composition over class inheritance". If we start inheriting from classes our entire codebase will turn instantly into a nightmare of dependencies and spaghetti, and all the cool kids won't want to hang out with us.

Well, the good news is that all those cool kids are off doing functional programming badly now, so you don't have to worry about them. As for the nightmare hellscape of inheritance... well, _Design Patterns_ - from where that quote is taken - says "_favor_ object composition over class inheritance". Not "never use inheritance". I'm not going to get into why this is a great use case for inheritance, but trust me - it is. Feel free to make it work by just implementing the `Error` interface if you like. It's your life.

Having said all that:

```typescript
class MyServiceError extends Error {
    constructor(
        public readonly number: number,
        public readonly originalError: Error) {
            super('MyService failed to process a number')
            this.name = this.constructor.name;
        }
}
```

Boom. This is the nicest way of doing this. Maybe the only weird thing here is `this.name = this.constructor.name`, which is just making sure that the name of this error isn't `Error`, but instead is named after its constructor function (`MyServiceBadResponseError`).

Well, we now have all those lovely fields all ready for our structured logging. But how can we get a nice, structured bit of JSON out given that, even with our modifications, we still get:

```typescript
JSON.stringify(new MyServiceBadResponseError(303, new Request(), new Response, new Error())) 
// {"number":303,"originalError":{},"name":"MyServiceError"}'
```

This is better - but it's still not really what we want. Where's my `stack`? Where's the `message`? What about that original error?

One way would be to write a nice function to transform the object into a thing we can then send to `JSON.stringify`:

```typescript
function serializeMyServiceError(error: MyServiceBadResponseError): MyServiceBadResponseErrorDTO {
    return {
        name: error.name,
        message: error.message,
        stack: error.stack,
        number: error.number,
        originalError: error.originalError,
    }
}
```

This is pretty good:

```
{
  "name": "MyServiceError",
  "message": "MyService failed to process a number",
  "stack": "MyServiceError@http://localhost:8000/tojson/errors.html line 67 > eval:11:9\n@http://localhost:8000/tojson/errors.html line 67 > eval:17:15\nevaluate@http://localhost:8000/tojson/errors.html:67:68\ndoit@http://localhost:8000/tojson/errors.html:59:19\nonclick@http://localhost:8000/tojson/errors.html:1:1\n",
  "number": 303,
  "originalError": {}
}
```

But I still can't see my original error. How about:

```typescript
function serializeMyServiceError(error: MyServiceBadResponseError): MyServiceBadResponseErrorDTO {
    return {
        name: error.name,
        message: error.message,
        stack: error.stack,
        number: error.number,
        originalError: { name: error.originalError.name, message: error.originalError.message, stack: error.originalError.stack },
    }
}
```

Yay!

```
{
  "name": "MyServiceError",
  "message": "MyService failed to process a number",
  "stack": "MyServiceError@http://localhost:8000/tojson/errors.html line 67 > eval:11:9\n@http://localhost:8000/tojson/errors.html line 67 > eval:17:15\nevaluate@http://localhost:8000/tojson/errors.html:67:68\ndoit@http://localhost:8000/tojson/errors.html:59:19\nonclick@http://localhost:8000/tojson/errors.html:1:1\n",
  "number": 303,
  "originalError": {
    "name": "Error",
    "message": "",
    "stack": "@http://localhost:8000/tojson/errors.html line 67 > eval:17:39\nevaluate@http://localhost:8000/tojson/errors.html:67:68\ndoit@http://localhost:8000/tojson/errors.html:59:19\nonclick@http://localhost:8000/tojson/errors.html:1:1\n"
  }
}
```

But what if my original error wasn't an `Error`? What if you didn't know what sort of error it was going to be?

OK, finally, this is what we're trying to get to here: `toJSON()`. A method we call to get the (unstringified) JSON representation of an object.

```typescript
class MyServiceError extends Error {
    constructor(
        public readonly number: number,
        public readonly originalError: Error) {
            super('MyService failed to process a number')
            this.name = this.constructor.name;
        }
    
    toJSON() {
        return {
            name: error.name,
            message: error.message,
            stack: error.stack,
            number: error.number,
            originalError: originalError.toJSON(),
        }
    }
}


class HttpError extends Error {
    constructor(public readonly request: Request, public readonly response: Response) {
        super('the badness');
        this.name = this.constructor.name;
    }

    toJSON() {
        return {
            name: this.name,
            message: this.message,
            stack: this.stack,
            request: this.request,
            response: this.response,
        }
    }
}


JSON.stringify(303, new HttpError(new Request('hello', new Response())).toJSON())
```

```
{
  "name": "MyServiceError",
  "message": "MyService failed to process a number",
  "stack": "MyServiceError@http://localhost:8000/tojson/errors.html line 67 > eval:20:9\n@http://localhost:8000/tojson/errors.html line 67 > eval:35:15\nevaluate@http://localhost:8000/tojson/errors.html:67:68\ndoit@http://localhost:8000/tojson/errors.html:59:19\nonclick@http://localhost:8000/tojson/errors.html:1:1\n",
  "number": 303,
  "originalError": {
    "name": "HttpError",
    "message": "the badness",
    "stack": "HttpError@http://localhost:8000/tojson/errors.html line 67 > eval:3:9\n@http://localhost:8000/tojson/errors.html line 67 > eval:35:39\nevaluate@http://localhost:8000/tojson/errors.html:67:68\ndoit@http://localhost:8000/tojson/errors.html:59:19\nonclick@http://localhost:8000/tojson/errors.html:1:1\n",
    "request": {},
    "response": {}
  }
}
```

Gives the same output as above.

First, just on its own, this is a _good object oriented idea_. Let's leave the decisions about how our complex, odd-looking objects get turned into JSON up to those objects themselves. We can even send in complicated blobs of objects as private properties of the object, then only `toJSON()` the bits we really care about.

But second... ah! Just look at this:

```typescript
JSON.stringify(303, new HttpError(new Request('hello', new Response())))
```

You _don't need to call `toJSON()`_! `JSON.stringify` will call it for you. In fact, it'll call it _recursively_ on each of the (enumerable) properties of your object. So you can just have `toJSON` return the `originalError`, and `JSON.stringify` will call it if it's there, or do its own thing if it's not. Behold, delayed binding (or polymorphism - you choose) in action, actually working for you. And actually built into the language.

Just as `toString()` will get called recursively as objects are coerced into strings, so `toJSON()` gets called recursively as you coerce objects into a JSON string.

This approach can be applied to everything - I've used errors here as I think this is an area we could all do better in. But the same approach could be used with all your domain objects. How often do you find yourself serializing your objects to JSON to send over the wire? And how often are they nested and awkward to work with? How often do you write your custom serializer that then instantly gets sent straight to `JSON.stringify`? It would be much easier just to define the JSON representation of your object _once_, canonically, and then rely on `JSON.stringify` to do the right thing. Less code, less work, more fun: object oriented programming.

## So what?

More broadly, why don't we just implement `toString()` and `toJSON()` on _all our objects_? We'd never be stymied by `[object Object]` again - we'd be in control of what we read in our consoles and debugger. We'd never get fooled by some weird serialization of one of our objects. And structured logging would be simple, easy and fun (Rich Hickey only gives you one of these)! JavaScript gets damned as a bad language, but there are shining points of awesomeness in its design, and I think protocols that use these two methods are two of them.









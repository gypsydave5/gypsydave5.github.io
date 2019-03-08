---
layout: post
title: "Your first statically typed language"
date: 2018-10-19 15:18:43
tags:
  - languages
  - beginners
  - types
published: false
---

Most people's first programming language is a dynamically typed, interpreted
language - JavaScript, Python or Ruby. These are excellent languages to learn
 programming with[^1] - but there's a separate category of languages in
widespred use: statically typed, compiled languages - C, Go, Java, C# and
many others. This article will try to explain the difference between the two
language categories, consider some of their advantages and disadvantages, and
then consider what would be a good choice of statically typed language for a new
programmer to learn.

- [Who is this for](#who-is-this-for)
- [What is a statically typed, compiled language](#what-is-a-statically-typed-compiled-language)
- [Advantages](#advantages)
- [Disadvantages](#disadvantages)
- [Where should I start](#where-should-i-start)

## Who is this for?

The target audience of this article is someone who is comfortable with a
programming in a dynamically typed language and who is interested in learning a
statically typed language, and wants to know why it might be worth while.

## What is a statically typed, compiled language?

There are two pairs of opposites - _dynamically typed_ vs. _statically typed_,
and _compiled_ vs. _interpreted_.

### Dynamic vs Static typing

In real life, if someone asked you:

> Could you measure the length of the colour blue?

You'd be confused - the person who was asking you that question has made a
mistake about what 'blue' is. Maybe you could have a go at answering the
question (you could say "The wavelength of blue, is that what you mean?"), but
it's more likely that you'll say "What?" and ask them to repeat themselves. The
question does not make sense.

Computer programming languages have the same idea of something that makes sense
or not. By having the idea of _types_ in a language, the program you have
written can be checked to see if it makes sense. _Type checking_ will tell you
that you can't get a 'length' of 'blue'.

Type checking can happen at one of two times - when the program is running and
or sometime before then. Dynamically typed languages have their types checked at
run time, while statically typed languages have their types checked before
then - usually at compile time.

In a statically typed language we can assign a type to a variable - saying that
all the values in this variable will be of a particular type. We can do this
explicitly. In dynamically typed languages none of the variables have a type.
For instance, in JavaScript we can do the following:

```javascript
var x = 1
x = 7
x = "hello"
x = { say: "goodbye" }
```

The variable `x` is initialized with the value `1` - `1` is a number. Then the
value is changed to `7` - another number. Then on the next two lines we reassign
`x` to the string `"hello"` and finally an object.

JavaScript doesn't mind if we do this - `x` can be anything we want it to
be.

A statically typed language would not let you do this. In TypeScript, a
statically typed variant of JavaScript, we could write this as the equivalent:

```typescript
var x: number = 1
x = 7
x = "hello"
x = { say: "goodbye" }
```

We've added a _type declaration_ to the variable `x`, declaring that it has a
type of `number`. The first reassignment to `7` will be fine - 7 is definitely a
`number`. But `"hello"` is definitely not a `number`, and nor is `{ say:
"goodbye"}`; TypeScript will tell us that we've done something naughty.

### Compiled / Interpreted

TypeScript's type checking is being performed at compiliation time by the
TypeScript compiler. In an interpreted language each line of the code is read
and executed in sequence, one after the other,[^1] by an interpreter, which
builds up the running program line by line.

Conversely the compiler is a program that reads the code that you've written and
changes it into another sort of code. In the case of TypeScript it compiles to
JavaScript so that it can run in a JavaScript environment - say the browser. But
it could be compiling to an assembly language as in the case of C.

During compilation there is almost always _type checking_ step - it's
this step that will make the TypeScript compiler yell at you for trying to use a
`string` like it's a `number`. Type checking is useful for the compiler as it
allows it to make optimizations in the performance of the software - if a
variable is always going to be a `number` it can optimize the memory locations
used. But it's also useful for programmers.

## Advantages

Type checking lets a programmer know that what they've written is correct in
some fundamental way without having to run the program. Let's take a look at
another example, this time using type declarations within a function signature
to illustrate one of the more common mistakes that I make in JavaScript.

```javascript
function triangular (n) {
    if (n === 1) {
        return n
    } else {
        return n + triangular(n - 1)
    }
}
```

Here we have a function which returns the nth [triangular number][triangular]
recursively. Let's try it out:

```javascript
var aNumber = 5

triangular(aNumber)
// => 15
```

Which works as expected. But what if somebody (i.e. me) has been storing numbers
as strings somewhere in the code:

```
var anotherNumber = '5'

triangular(anotherNumber)
// => '510'
```

Not the answer we want. This is a really easy mistake to make - I've
seen a team work on a bug for days because they hadn't realised a JSON
field they were reading in was a `string` and not a `number`.

If we try to make the same mistake in TypeScript:

```typescript
function triangular (n: number): number {
    if (n === 1) {
        return n
    } else {
        return n + triangular(n - 1)
    }
}

var n: string = '5'

triangular(n)
```

(The `number` after the colon is declaring that the `triangular` funciton is
returning a `number`)

We will get the following error from the TypeScript compiler:

```
triangular.ts:11:24 - error TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.

11 console.log(triangular(n))
```

The TypeScript compiler will not let us make the same mistake that we made in
JavaScript- it picks up that the variable `n` is a `string`, and that strings
cannot be numbers. Many developers like the way that a statically typed language
can prevent this category of error entirely.

This type checking step is so useful that it is often performed outside of the
compiler and integrated into the editor - you could think of an IDE like
IntelliJ as being a text editor hooked into a type checker. By doing this the
text editor can provide tool tips and autocompletion. For instance if the
editor knows the type of an object, it can alert you to the methods that are
available to be caled on it. This can speed up development: you no longer have
to remember an API or look it up; it's right there in your editor as you're
writing.

In Test Driven Development, you will often treat a failure to compile as being
the 'first test' that you need to make pass before you do any of the substantive
work.

## Disadvantages

This all sounds good - but what are the trade offs of using a statically typed,
compiled language?

### Compilation

Compilation of a program can take a long time. Less time these days with fast
computers and good compilers, but still something like two or three minutes in
the worst cases I've experienced. If your workflow is reliant on fast, tight
feedback loops then you might start to find a compiler annoying you as your
program increases in size.

### Syntax Explosion

If you're used to a dynamically typed language, the verbosity of a statically
typed language can be extremely off-putting. Having to declare the types of
every variable and function parameter can get very wearing on the eyes. A modern
language will try to take away the strain of this by inferring the type of
variables where it can, but older statically typed languages like Java, C#, C++
and C can look very verbose.

### Interacting with the world

The verbosity of a statically typed language is made very clear at the
boundaries of a program - where it interacts with 'the world'. A number of extra
steps are required to wrangle the data coming your system. This becomes apparent
when parsing JSON - to get the full benefit of types in your system you'll have
to take the `JSON` type and turn it into one of your types, which can be pretty
arduous. A dynamic language makes this a lot easier (although more open to type
errors as seen above).

### No REPL based development

Most compiled languages do not have support for a Read-Evaluate-Print-Loop,[^2]
and do not lend themselves to the sort of interactive development seen in
languages such as Clojure. If you work in this way you'll miss it - if you don't
it won't make a bit of difference to you.

## Where should I start?

If I had a lot of experience with JavaScript then there might be a good argument
to try TypeScript instead, but I find that languages that compile to JavaScript
introduce a layer of overhead and tooling that can stop you focussing on the
language.

I would advise steering away from Java as there's a lot of unnecessary cruft
and complication in the language. If you did want to look at a statically
typed language built on the JVM I would say Kotlin is an excellent choice.

The best choice in my option is the Go programming language. It's not got a
terribly complicated type system (there are no generic types as in other
languages), the language is small and easy to learn, the tooling and
documentation are excellent, and it's increasingly popular. Take a look at the
excellent [Go By Example][gobyexample] or [Learn Go With Tests][]

[^1]: There are some subtleties to this - often a language interpreter will compile parts of the code on the fly, and compiled languages can have sections of code whose types can only be worked out after compilation when we run the program (at 'run time').

[^2]: There is, of course, some nuance to this. For instance languages that run, on the Java Virtual Machine (JVM) _can_ support a REPL by sending the compiled Java Byte Code emitted from the REPL directly to a running instance of the JVM.

[triangular]: https://en.wikipedia.org/wiki/Triangular_number
[learngo]: https://github.com/quii/learn-go-with-tests
[gobyexample]: https://gobyexample.com/

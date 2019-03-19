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

Most people's first programming language is a dynamically typed, interpreted language - JavaScript, Python or Ruby. These are excellent languages to learn programming with - but there's a separate category of languages in widespred use: statically typed, compiled languages - C, Go, Java, C# and many others. This article will try to explain the difference between the two language categories, look at their advantages and disadvantages, and then consider what would be a good choice of statically typed language for a programmer who is only familiar with dynamically typed languages to learn.

- [Who is this for](#who-is-this-for)
- [What is a statically typed, compiled language?](#what-is-a-statically-typed-compiled-language)
- [Advantages](#advantages)
- [Disadvantages](#disadvantages)
- [Where should I start?](#where-should-i-start)

## Who is this for?

The target audience of this article is someone who is comfortable with programming in a dynamically typed language and who is interested in learning a statically typed language, and wants to know why it is worth while. The examples are in JavaScript, TypeScript, Python and Go, but no knowledge of these
languages should be required. It is based on my own experience of being a self-taught developer who started working in Ruby and JavaScript and has extended to languages like Go, TypeScript, Kotlin and Rust.

## What is a statically typed, compiled language?

There are two pairs of opposites to look at here: _dynamically typed_ vs. _statically typed_, and _compiled_ vs. _interpreted_. Let's go through them in that order.

### Dynamic vs Static typing

If someone asked you:

> What's five added to a banana?

You'd be confused - what do they mean? It looks like they've made a mistake. Maybe they don't know what the meaning of 'add' is, or what a 'banana' is. Maybe they have a different meaning of 'add' to us. Something has gone wrong somewhere though, as their question doesn't make sense to us.[^1]

Programming languages have a way of telling us that an expression written in the language do or do not make sense. They do this by using the _type_ that every value in a programming language has. In dynamically typed languages we only really become aware of types when we use a value of one type in the wrong way - when we say something that doesn't 'make sense'.

For instance, in Python we can write this:

```python
5 + "banana"
```

Try saving that in a file called `typecheck.py` and executing it with `python typecheck.py`. You should get the following error in your terminal:

```
Traceback (most recent call last):
  File "typecheck.py", line 1, in <module>
    5 + "banana"
TypeError: unsupported operand type(s) for +: 'int' and 'str'
```

This is a type error - you can tell that from the `TypeError` bit of the message. The error is telling you that you can't `+` the types `int` and `str` together. Just like you don't know how to add together 5 and a banana, neither does Python.

This type error is thrown by a _type checker_. The type checker kicks in when the Python program is run and checks that the two things that are being `+`ed together are of the right type.[^2]

Type checking can happen at one of two times: when the program is running (commonly called 'run time') or sometime before then. Dynamically typed languages have their types checked at run time - this is what happened with the Python program we ran above; the type error become apparent when the program was run. Statically typed languages have their types checked before they are run.

#### Type annotations

In order for the type checker to accurately check the types in a statically
typed language, you will often have to explicitly declare the type of a variable
through a _type annotation_. A type annotation is a little extra information you
add to a variable to say what type it is. In English we can imagine adding type
annotations to our nouns and verbs as extra information in parentheses. So our
simple sentence:

> What's five added to a banana?

Becomes

> What's five (which is a number) added (adding, if you didn't know, is something you do with numbers) to a banana (which is a fruit)?

Which might be good evidence that natural language is not a place for type annotations.

That that with these English type annotations we don't need to know what 'five' is, what a 'banana' is, and what 'addition' is, to know that this sentence doesn't make sense. We don't even need to know what a 'number' is. We just know that the verb in the middle needs two nouns to be of the type 'number' for this sentence to be valid. We could perform this kind of check automatically just by looking at the symbols without having to know anything about their meaning. The type checker in for a statically typed language works in the same way.[^3]

For instance, in TypeScript, a statically typed variation of JavaScript:

``` typescript
var theNumberFive: number = 5
```

This declares that the variable `theNumberFive` has the type `number`, and assigns the value `5` to it.

The equivalent in JavaScript would be:

``` javascript
var theNumberFive = 5
```

Exactly the same, just without the type annotation.

We can also add type declarations to function signatures. The function `add` in JavaScript:

``` javascript
function add(n1, n2) {
    return n1 + n2
}
```

looks like this in TypeScript:

``` typescript
function add(n1: number, n2: number): number {
    return n1 + n2
}
```

We're saying that the function `add` takes two arguments, `n1` which is a `number` and `n2` which is a `number`, and returns a value which is also a `number`.

These annotations will be used by the TypeScript type checker, which runs when the TypeScript is _compiled_.

### Compiled / Interpreted

In an interpreted language such as JavaScript each line of the program is read and executed in sequence, one after the other,[^4] by an interpreter, which builds up the running process from the program you wrote, line by line.

Compilation is the act of turning the program you've written in one language into another language. For TypeScript, the target language is JavaScript. And during the compilation - at 'compile time' - the type checker will analyse the TypeScript program for any errors.

Compilers are usually used to translate a high level programming language (like JavaScript) into a lower level language like an assembly language or machine code. In the case of TypeScript, the compiler outputs anoher high level language - JavaScript.[^5]

Compiled vs. interpreted is barely ever a cut and dried distinction when with a particular programming language - an interpreter will sometimes have a compilation step which runs just before the code is executed,[^6] and the output of a compiler will have to be run by an interpreter. In addition, being compiled or interpreted is not necessarily a property of the language itself. Compilers have been written for languages that are normally interpreted, and interpreters for languages that are normally compiled.

For a statically typed, compiled language, the compilation step is where the type checker runs. Type checking is useful for the compiler as it allows it to make optimizations in the performance of the software - if a variable is always going to be a `number` it can optimize the memory locations used.

## Advantages

### Type checking catches mistakes

Let's put this all together and write our example natural language 'expression' in both JavaScript and TypeScript we will soon seen one of the advantages of a statically typed language

``` javascript
var five = 5
var banana = "banana"

function add(n1, n2) {
    return n1 + n2
}

add(five, banana)
```

which will give us the result

```javascript
'5banana'
```

Oh JavaScript... more than happy to `+` _anything_ together.[^7] It's easy to laugh at this sort of error, but I've seen teams working on JavaScript bugs for days based on a number being stored as a string. It's an easy mistake to make. It's also the sort of bug that will _never, ever_ happen to you - until it happens to you.

But if we try to replicate the same bug in TypeScript

```typescript
var five: number = 5
var banana: string = "banana"

function add(n1: number, n2: number): number {
    return n1 + n2
}

add(five, banana)
```

When we compile this with the TypeScript compiler[^8]

```
add.ts:8:11 - error TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.

8 add(five, banana)
            ~~~~~~


Found 1 error.
```

The TypeScript compiler has caught our mistake and has even underlined where we went wrong - we can't put a `string` where a `number` is meant to go.

This is the biggest advantage of static typing from the programmer's perspective; the type checker makes sure that we're not doing anything _stupid_ like using a `string` like it's a `number`. All of a sudden we've got a new level of certainty about how the program we've written will work - without even running it.

### Editor integration

But the fun of type checking doesn't end with compilation - far from it. Because a type checker can be run even before you compile your program it can be integrated with your text editor to give you information about your program as you're typing. Because the type annotations declare what the type of a variable is, the editor can now tell you useful things like which methods are available to use on it.[^9]

[!gif of editor completion]

### An extra test for free

If you're a fan of Test Driven Development then the type checker is giving you a test for free.

### Compiled code runs faster

Compilation doesn't just translate one language into another; the compiler also looks at your program and tries to work out ways to make it run faster or more efficiently. Recursive function calls get turned into simple loops, for instance.

## Disadvantages

This all sounds good - but what are the downsides of using a statically typed, compiled language?

### Compilation takes time

Compilation of a program can take a long time. Less time these days with fast computers and good compilers, but still something like two or three minutes in the worst cases I've experienced. If your workflow is reliant on fast, tight feedback loops then you might start to find a compiler annoying you as your program increases in size.

### Types need more syntax

If you're used to a dynamically typed language, the verbosity of a statically typed language can be extremely off-putting. Having to declare the types of every variable and function parameter can get very wearing on the eyes. A modern language will try to take away the strain of this by inferring the type of variables where it can, but older statically typed languages like Java, C#, C++ and C can look very verbose.

### The world isn't typed

The verbosity of a statically typed language is made very clear at the boundaries of a program - where it interacts with 'the world'. A number of extra steps are required to wrangle the data coming your system. This becomes apparent when parsing JSON - to get the full benefit of types in your system you'll have to take the `JSON` type and turn it into one of your types, which can be pretty arduous. A dynamic language makes this a lot easier (although more open to type errors as seen above).

### No REPL based development

Most compiled languages do not have support for a Read-Evaluate-Print-Loop,[^10] and do not lend themselves to the sort of interactive development seen in languages such as Clojure. If you work in this way you'll miss it - if you don't it won't make a bit of difference to you.

## Where should I start?

So what's a good statically typed, compiled language to start with?

If I had a lot of experience with JavaScript then there might be a good argument to try TypeScript, but I find that languages that compile to JavaScript introduce a layer of overhead and tooling that can stop you focussing on the language.

I would advise steering away from Java as there's a lot of unnecessary cruft and complication in the language, some of which is a hangover from C. For instance, compare

``` java
User user = new User()
```

in Java, always makes me feel like I've written the word `user` at least two too many times, to this in Go

```go
user := NewUser()
```

If you _did_ want to look at a statically typed language built on the JVM, Kotlin is a good choice.

The best choice in my opinion is the [Go programming language][go]. It has a simple type system (there are no generic types to worry about), the language's syntax is small and easy to learn, the tooling and documentation are best in class, and it's increasingly popular. Take a look at the excellent [Go By Example][gobyexample] or [Learn Go With Tests][learngo].

## What do you think?

Do you have any experience of transitioning from dynamically typed languages to staticly typed languages. Or vice versa? What were the hardest parts? What advice would you offer? Which language(s) do you think make the best introduction to static typing?

[triangular]: https://en.wikipedia.org/wiki/Triangular_number
[learngo]: https://github.com/quii/learn-go-with-tests
[gobyexample]: https://gobyexample.com/
[go]: https://golang.org/
[JavaScriptWAT]: https://www.destroyallsoftware.com/talks/wat

[^1]: We could say that the sentence is syntactically correct, but is semantically nonsense.

[^2]: Try and imagine what would happen if there were _no types_ in a language. All you would have is bits floating around in memory. How would you know where the 'number' started? Or ended? Or which bits of the memory were the program? This is why all programming languages are typed - programming would be impossible without them.

[^3]: Although often the type checker _does_ know the types of the values it's looking at - it will know that `1` is a number. This is how type inference works, helping statically typed languages become a lot less verbose. For instance in Go we can just say `x := 1` and the type checker will be able to infer the type of `x` to be a number.

[^4]: There are some subtleties to this - often a language interpreter will compile parts of the code on the fly, and compiled languages can have sections of code whose types can only be worked out after compilation when we run the program (at 'run time').

[^5]: This is sometimes called _transpilation_.

[^6]: This is called a 'just in time' compiler for obvious reasons.

[^7]: If you've not watched Gary Bernhardt's [JavaScriptWAT] video, now would be a good time.

[^8]: If you're interested in seeing this for yourself, you will need a NodeJS environment on your computer. Then you will need to install the TypeScript compiler from NPM by running `npm install -g typescript`. To compile a TypeScript file, i.e. one called `add.ts`, run `tsc add.ts`. The compiled JavaScript output will be in a file called `add.js` if there are no compilation errors.

[^9]: This sort of assistance _is_ available in dynamically typed languages, but not to the same degree.

[^10]: There is, of course, some nuance to this. For instance languages that run, on the Java Virtual Machine (JVM) _can_ support a REPL by sending the compiled Java Byte Code emitted from the REPL directly to a running instance of the JVM.

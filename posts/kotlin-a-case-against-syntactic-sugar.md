---
layout: post
title: "Kotlin is Terrible"
date: 2018-01-09 17:10:35
tags:
    - Kotlin
    - Theory
published: false
---

I've been writing a lot of Kotlin at work for the last three months. Nice shiny
new job, nice shiny new language. And for the most part it is nice and shiny.
Think Groovy meets Scala with a sprinkling of something like Rust or Go.

But I'm intolerant in my old age. If you're going to create a new language in
the 21st Century it'd be nice if you didn't make design decisions that make me
want to scream.

## How do you say 'function'?

Kotlin is partly sold as a more 'functional' Java. Not as functional as Scala,
but getting there.

So how do you write a function?

```kotlin
fun addTwo (number: Int): Int {
  return number + 2
}
```
But maybe that's a bit too verbose - we could just return the result as... an
assignment type thingy?

```kotlin
fun addTwo (number: Int): Int = number + 2
```

So now I'd like to use this nice named function to `map` over a list.

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map(addTwo)
```

This, of course, doesn't work. Because ... wait, what? Why doesn't this work?

Well even though that thing looks like a function, it's going to get compiled
down to some Java bytecode which will turn it into a method on a class. I have
no idea how that happens - but I imagine it's something like using a different
vtable for variables and functions like we get in Common Lisp.

So we need to reference the function like this:

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map(::addTwo)
```

Just... just do it. Don't ask why.

But what if I just wanted to inline `addTwo`, like I was writing a futuristic
language like JavaScript?

Easy - you just pass in a `lambda`. These just look like they do in Groovy, but
in Groovy they were called closures.

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map({number -> number + 2})
```

You don't even need to use the parenthesese if the last argument to your
function is a Lambda - it can look just like Ruby.

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map { number -> number + 2 }
```

And to really round off the fun, we can get rid of `number` and replace it with
the default receiver - `it`.

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map { it + 2 }
```

Notice how there's no `return` in a lambda? It's just like Rust or Ruby or
whatever - each lambda just evaluates to the final expression.

In fact, if you _do_ return from a lambda, you'll actually be returning from the
outer function. How useful is that! You'll end up only mapping over _one_ of the
numbers.

If you really _want_ to return from the lambda - or block, did I say that
they're sometimes called blocks when they're the last argument. It's good to
have more that one name for the same thing, right? So if you want to return
early you can use the `return@map` syntax.

Or, you know, use an anonymous function.

Oh, did I not mention anonymous functions? They're just like functions, and
lambdas, and closures, and blocks except they have a different syntax _and
return works_. They're

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map(fun (number: Int): Int { return number + 2 })
```

Or we make it an expression ... in which case we don't have to return it...

```kotlin
val listOfNumbers = listOf(1, 2, 3, 4)
listOfNumbers.map(fun (number: Int): Int = number + 2)
```

And I've not even mentioned that it's possible to stick an `invoke` method on
objects to make them behave like functions á la Scala:

```kotlin
object addTwo {
    invoke(number: Int) = number + 2
}
```

## So what, Dave?

Am I against having different solutions to problems? Certainly not? Do I hate
either implicit or explicit returns? No.

What I hate here is the lack of opinion, the confusion of paradigms. Why




[^1]: Execept in Groovy they got called closures because it's important to have
  as many words for the same idea as possible.

[SO]: https://stackoverflow.com/questions/48112081/why-does-kotlin-have-two-syntaxes-for-lambdas-anonymous-functions

---
title: Go Is An Object Oriented Programming Language
description: but it is
published: true
date: 2024-04-12 22:52:55
tags:
  - golang
  - object-oriented programming
---

I get into this argument every three months or so, so I’m just going to write it all down here to remind me of the key points to why Go is an object-oriented programming language.

## What even is an Object-Oriented Programming Language?

First up, the idea of a language “being” object-oriented or ‘functional’ or whatever isn’t really useful. Essentialist nonsense. Go, and all languages, have features. They are designed, the designers made decisions about what sorts of features the language would have.

I could write Object-Oriented code in Haskell, or OCaml, or Clojure or Racket or whatever - I could. How successful I would be down to how the features of the language supported writing object-oriented code. More precisely, how they supported an object-oriented design.

So stop asking essentialist crap about whether they _are_ object-oriented - take a functionalist approach and ask if they let you do OO easily.

## Like, what even is object-oriented programming, man?

I don’t want to get into the tall weeds with this one, as there’s lots of writing out there. Go read Alan Kay or something:

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things. It can be done in Smalltalk and in LISP. There are possibly other systems in which this is possible, but I’m not aware of them.

which I guess means there are no OO languages, so we’ll have to loosen up from Alan’s description. Page-Jones once wrote a long feature set:

*   Encapsulation
*   Information/implementation hiding
*   State retention
*   Object identity
*   Messages
*   Classes
*   Inheritance
*   Polymorphism
*   Genericity

Which I think goes too far.

So here’s what I think object-oriented programming is about.

Objects.

And as we all know, Go doesn’t have objects, so it can’t be OO. Case closed.

But wait… what are these `struct` things?

Look like objects.

Smell like objects.

Taste like objects.

Yeah, they’re objects. Why are they called structs then? Go ask Rob Pike, I don’t know. I guess it was a canny marketing move to distinguish Go from Java. Remember, OO isn’t cool anymore, it’s boomer coding. So these structs, they’re just data right. We’re safe. Functions working on data. Great. We’ll call it data-oriented programming or something, and we can sell some books and a few workshops. Just data.

Well…

They would be if someone hadn’t _gone and ruddy put methods on them_.

I mean,

`<picard-come-on.gif>`

You’ve now got enough there to get message passing off the ground. At least as much as Java gives you, right? And you’re not going to say that Java isn’t good for writing OO? (Well, Alan Kay would).

## But encapsulation...

It’s fine, though, because all the data and methods on an ~object~ struct is completely public. There’s no encapsulation going on here right?

Well, yes and…

If you don’t export an identifier from a package, it’s essentially hidden from the calling code. And struct fields and methods, well they’re identifiers… so.

Yeah, we’ve got encapsulation in Go.

## Ahhhh but Classes and Inheritance

`<batman-slap.gif>`

Classes aren’t an object-oriented programming feature. They’re a code reuse feature. Class is just a function for making an object (and they also happen to be objects too in all the beaauuuuuutiful OO languages like Ruby and Smalltalk and even JavaScript, but that doesn’t matter right now.)

Well, if I want a function in Go that makes me a struct… I can just write one instead of constructing the struct from nothing like some barbarian.

Oh look, I’ve got a ~class constructor~ struct maker function.

Inheritance? INHERITANCE?

`<BIGGER-BATMAN-SLAP.gif>`

Inheritance is a code-reuse technique, with a bit of type-system pokery on the side if you have a static type thing going on with your language. And, I hate to break it to you all, but object-oriented programmers have been actively trying to avoid inheritance for the last [checks notes] THIRTY YEARS since the Gang of Four told you to.

> Favor object composition over class inheritance.

If you’re still messing around with “A DOG IS AN ANIMAL” inheritance when you’re explaining object-oriented programming, then what rock have you been living under for the last THIRTY YEARS? There are entire functioning adults who are younger than this.

And guess what? Go helps you to do this by making class inheritance impossible. No classes? No inheritance. Simple.

It _also_ helps you by making ~object~ struct composition as simple as [embedding on struct](https://gobyexample.com/struct-embedding) in another. Look, ma! I just did the delegation pattern in one line of code.[^1]

So not only is Go good for object-oriented programming, it’s also good for _modern_ object-oriented programming.

## HURR DURR INTERFACES

You should maybe have taken the point that Go was _very_ object-oriented when they gave you interfaces. I guess nobody could think of a better word and Smalltalk already had protocols? Interfaces give you the useful type information bit of inheritance (“A DOG IS AN ANIMAL WOOOF WOOOF SEE SPOT RUN”) that lets you do the other great bit of Gang of Four advice FROM THIRTY YEARS AGO:

> Program to an interface, not an implementation.

So instead of knowing the concrete object that’s you’ve received, you instead can “program to an interface” - some collection of properties - in Go’s case, methods - that the object implements.

Go’s interfaces are a little different to those in nearly every other language in that they are _structurally subtyped_ rather that _nominally typed_. Which is fancy talk for saying that I don’t care what my ~object~ struct _is_, I only care what it can _do_.

(Lol we’ve circled back to the beginning and Go’s type system is anti-essentialist too…)

This means that you get what the dynamic object-oriented folk call [_duck typing_](https://en.wikipedia.org/wiki/Duck_typing) going on, but checked at compile time just so you don’t try and make a whale fly.

Go would obviously still be an object-oriented language even if it didn’t have this feature, but what it means is that you’re left with an extremely unique object-oriented language that improves the decoupling provided by polymorphism by making interfaces a _consumer driven property_ of the system, and giving you multiple (interface) inheritance. I don’t need to tag up my ~objects~ structs to say they implement a particular interface; I just put the required (exported) methods on them and hey presto.

Go interfaces are more like bundles of function signatures in a more FP language. All you’re saying is that this ~object~ struct needs to be _all_ these functions.

This decoupling also shifts Go closer to Alan Kay’s “extreme late-binding of all things.” (I think, might be wrong here), by moving the knowledege of the interface into where the object is being used rather than where it’s being passed, but I might be misunderstanding this.

## In conclusion

Go is a _very_ object-oriented programming language. More so than Java I think we can safely say, and edging towards something like a statically-typed Smalltalk without inheritance.

If you choose not to use these features, or write in this style, that’s fine. In my view you’re throwing over forty years of software design out with the dirty Java bathwater.


[^1]:  This is like Kotlin, which also makes delegation (and so composition) easier.



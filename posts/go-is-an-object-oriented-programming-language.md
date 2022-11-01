---
title: Go Is An Object Oriented Programming Language
description: It just is and you should all deal with it
published: false
date: 2022-08-09 21:56:49
tags:
  - Golang
  - OO
---

## So

Yeah, so. This is a big question. But let's first get one thing put to bed: There is no such thing as an object-oriented programming language,[^4] there are just programming languages you can do object-oriented programming in to a greater or lesser extent.

## What even is object-oriented programming anyway?

> First of all, think of an OO system as a bunch of intelligent animals inside your machine (the objects) talking to each other by sending messages to one another. Think “object.” Classes are irrelevant—they’re just a convenience provided for the compiler. [^1]

### Meilir Page-Jones' List

- Encapsulation
- Information/implentation hiding
- State retention
- Object identity
- Messages
- Classes
- Inheritance
- Polymorphism
- Genericity


###  Alan Kay's definition

Alan Kay gave a very direct answer to a very direct question about what object-oriented programming is in 2003:

> OOP to me means only messaging, local retention and protection and hiding of state-process, and extreme late-binding of all things. It can be done in Smalltalk and in LISP. There are possibly other systems in which this is possible, but I'm not aware of them. [^3]

Sounds grumpy. I like it. So our question becomes "does Go get close to having the featurers required to perform "

Well, messaging maps to Page-Jones' list well, and "local retention and protection and hiding of state-process" defiitely includes "encapsulation" and "information/implementation hiding"

So let's go through the list.

In his introduction, Page-Jones recounts a (hopefully) fictional anecdote where he invites object-oriented gurus into a room to hash out just what object-oriented programming really is.

> When I first entered the realm of O.O., I decided to settle the definition of "object orientation" once and for all. I grabbed a dozen doyens of the object-ori ented world and locked them in a room without food or water. I told them that they'd be allowed out only after they'd agreed on a definition that I could publish to a yearning software world.
> 
> An hour of screaming and banging within the room was followed by silence. Fearing the worst, I gingerly unlocked the door and peered in at the potentially gory sight. The gurus were alive, but were sitting apart and no longer speaking to one another.
>
> Apparently, each guru began the session by trying to establish a definition of object orientation using the time-honored scientific practice of loud and repeated assertion. When that led nowhere, each of them agreed to list the properties of an object-oriented environment that he or she considered indispensable. Each one created a list of about six-to-ten vital properties.
>
> At this point, they presumably had two options: They could create one long list that was the union of their individual lists; or, they could create a briefer list that was the intersection of their lists. They chose the latter option and produced a short list of the properties that were on all the individual lists. The list was very short indeed. It was the word "encapsulation."[^2]

## Encapsulation

All this means is "putting stuff together that ought to be together". It's pretty much the definition of an object. Just as you can't have life on earth without cells, you can't have OO without objects. And just as you can't have cells without a cell membrane, you can't have an object without encapsulation.

So we keep all the data in the same place, _along with the methods/functions that act on that data_. And that's it.

Encapsulation in Go happens at two levels:

- modules
- types

## Classes and Inheritance

If there's one opinion I would like to disabuse everyone who is reading this of, it is that object-oriented programming is all about classes and inheritance. It just isn't . If you think it is, let me assure you that you're wrong and have been wrong for nigh-on a quarter of a century.

> The Gang-of-Four Design Patterns book is, in fact, largely about replacing implementation inheritance (extends) with interface inheritance (implements)[^5]

This is a deep insight. And we can see the evidence for it in the GoF book:

> Favor object composition over class inheritance

> Program to an interface, not an implementation

If we translate these ideas into the constructs of Go, we can make some interesting observations.

Go doesn't have classes, and so has no mechanism for code reuse other than object composition. Composition in Go is a simple case of "embedding" objects (interfaces, structs), inside other objects. This goes for both structs _and_ interfaces. In GoF language, we'd call this "delegation".

But there is one layer of inheritance in Go, although we might have been trained all these years not to think of it as inheritance: interface inheritance, as Holub calls it. What in Javaland they would write as `implements` after a class to tell the world that this class implements (inherits!) an interface. But we don't think of this as inheritance in Go because (1) Go is obviously not an object-oriented programming language stop being weird Dave, and (2) we never have to declare that relationship in Go because, duh, structural sub-typing dude.




# Stupid thoughts

On encapsulation: is it possible to use the go module system so that a single module acts as a single object? Yes, I suspect so. Is this a good idea? I suspect not.

Interfaces are a mechanism of information/implementation hiding.

If you're

- passing messages
- that ask for help and don't ask for information
- which is to say, they tell don't ask.
- which is to say, if they have the information, they do the action. I don't ask for the information to do the action.
- if this is the case
- then we should only think about data when building our system _at the last possible moment_
- just as the messages are late bound to a method, so the data in the system is late-built

I think "tell don't ask" gets so misunderstood that it deserves a whole blog post/lightning talk. I think the consequences don't get thought about.

[^1]: Allen Holub.  _Holub on Design Patterns_ https://learning.oreilly.com/library/view/holub-on-patterns/9781430207252/Chapter01.html#:-:text=First%20of%20all,for%20the%20compiler.

[^2]: Meilir Page-Jones. 2000. Fundamentals of object-oriented design in UML. Addison-Wesley Longman Publishing Co., Inc., USA. Page-Jones, Meilir, _Fundamentals of Object-Oriented Design in UML_ p. 2.


[^3]: http://userpage.fu-berlin.de/~ram/pub/pub_jf47ht81Ht/doc_kay_oop_en

[^4]: Apart from Smalltalk, but that's another story.

[^5]: https://learning.oreilly.com/library/view/holub-on-patterns/9781430207252/Chapter02.html#:-:text=The%20Gang-of,interface%20inheritance%20(implements)

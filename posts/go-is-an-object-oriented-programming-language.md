---
title: Go Is An Object Oriented Programming Language
description: It just is and you should all deal with it
published: false
date: 2022-08-09 21:56:49
tags:
  - Golang
  - OO
---

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


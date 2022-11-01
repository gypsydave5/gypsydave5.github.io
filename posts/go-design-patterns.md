---
layout: post
title: "Go and Object Oriented Programming: Go and Design Patterns"
date: 2022-01-26 19:12:28
tags:
    - Golang
    - OO
    - DesignPatterns
published: false
---

## Introduction: Objects and Go

When you read the Gang Of Four design patterns book, you really shouldn't skip past the introduction. Yes, it's tempting I'm sure. Because, you know, you bought it for the patterns so that if anyone asks you about them in your next interview you can explain them.

But in order to understand the patterns and what they mean, you need to get a grip on what the authors want from you. And, well, they want a lot.

The first few times I tried to read this book I just didn't understand it. I think, like so much in software development, the concepts you find here are almost impossible to grasp until you've seen them a few times. The problems being addressed by these patterns are the problems of experienced developers.

As Grady Booch says in the Preface

> This book isn’t an introduction to object-oriented technology or design. Many books already do a good job of that. This book assumes you are reasonably proficient in at least one object-oriented programming language, and you should have some experience in object-oriented design as well. You definitely shouldn’t have to rush to the nearest dictionary the moment we mention “types” and “polymorphism,” or “interface” as opposed to “implementation” inheritance.

And what we find in the introduction is a description of a style of object-oriented programming that is almost a prerequisite for using the patterns. The two most surprising things about this style of OO are

1. It's not what you expect
2. It suits Go _really_ well

And it's expressed through two big ideas

### Interfaces, Not Implementation

The first is this:

> Program to an interface, not an implementation.[^6]

The idea here is that, instead of using to things in the system by their concrete implementation - real objects in the system - you should instead refer to them only as an interface. 

For me the classic example of this idea in Go is the [`io.Reader`](https://pkg.go.dev/fmt#Stringer) interface.[^5] Many functions and methods in the `io` package and beyond take arguments of this interface type. All an object in Go needs to do to implement this interface is have a method with the signature `Read(p []byte) (n int, err error)`.

The benefits of this are

- By adding this one method to our object, we can use it in a large ecosystem of tools for manipulating it as a byte stream
- By sharing this abstraction between all these tools, they no longer know or care what their arguments are. They are coupled together by something abstract - an interface - not something specific like a struct type. This is a far looser coupling.

In the GoF book, the idea of an interface is also quite abstract - they refer to them chiefly through the idea of an "Abstract Class", which is a class where none of the methods have been implemented. Go has no classes, abstract or otherwise. We have the `interface` type.

There are two things that I love about Go interfaces. The first is _structural sub-typing_, which sometimes gets called "duck typing" after the same idea that we see in dynamic object-oriented languages. The idea here is that if a type satisfies the structure of an interface, then it implements that interface, and can be used in places which expect that `interface` type. Which sounds a bit obvious when I say it, but you need to contrast the idea to a language like Java, where a poor type has to do all of the above _as well as_ be tagged to declare that it implements the interface.

Structural sub-typing is a lot more like the style of object-oriented programming you would see in a dynamic language like Smalltalk.

The second thing I love about the Go `interface` type is that it enforces a stricter encapsulation than the Go module system. Go interfaces only expose the public methods of an object - any public fields on a `struct` type are hidden. These interfaces help enforce a style of programming where you aren't just throwing around chunks of data, but are throwing around chunks of behaviour. It's more likely that you'll accumulate data and behaviour together in one object if you use interfaces in Go. And that combination is one of the better definitions of good object-oriented programming.

### Composition, Not Inheritance

Now I know what you're thinking: you cannot possibly do object oriented programming in Go, there's no inheritance. Neither good old fashioned classical inheritance in the style of Java or Smalltalk, nor fancy prototype-based inheritance like Self or JavaScript. And without inheritance, how can we do object-oriented programming? We can't write those wonderful examples we all remember where we have a `Dog` inheriting its methods from an `Animal` parent class. Which is what object-oriented programming is, right?

The Gang offer us a thin sliver of hope with the second of their principles of good object-oriented programming:

> Favor object composition over class inheritance [^2]

Well, this is good as we don't have classes or inheritance in Go. So composition it is.[^1] How do we achieve reuse with composition? Why... with delegation, of course!

> Delegation is an extreme example of object composition. It shows that you can always replace inheritance with object composition as a mechanism for code reuse.

And Go is good at delegation! Really good! In other object-oriented languages, extension through delegation could be a little awkward - much more awkward than simple inheritance. Imagine we want to do some delegation in Java: for each of the methods we want to delegate to, we'd have to write our own method in the delegater class to receive the message and delegate down to the delegatee, wiring each one up individually. Much harder than just writing `class Dog extends Animal`.[^3]

But Go is of course a modern object-oriented language, and wants to make it easy for us to do the right thing: so delegation in Go is as simple as embedding another object (be it concrete or abstract) in an object:

```golang
type Dog struct {
    Animal
}
```

We suffer (slightly) here in that we can't substitute a `Dog` for an `Animal` if the `Animal` is concrete, and we are missing out on a touch of encapsulation as the `Animal` can be addressed directly through the `Dog`: `Dog.Animal`. But on the other hand, we can substitute `Dog` for `Animal` if the `Animal` is abstract, and if we are really concerned about encapsulation we can either pass around an interface (as all the )

It almost feels like Go was made for design patterns: not only does its interfaces combine the best of dynamic typing with static typing through structural subtyping, but we also get forced to use composition instead of inheritance. We have no choice!

## Adapter Pattern

We want to use Object A in a place where Object B is expected. Object A is functionally equivalent to Object B - but it happens to differ in terms of its interface. This could be as simple as the order of arguments in a method, or the name of some methods. Or it could be a shade more complicated. But not too complicated an adaptation - anything too complicated is really the responsibility of the Bridge Pattern or the Facade Pattern.

The Adapter Pattern is just the way of mapping the interface of A to B. We wrap A up in an object that implements B's interface, translating the method calls (and properties) to the equivalent in A.

### Examples

Probably the most famous example of an Adaptor Pattern in Go is the `HandlerFunc` type, which adapts a function to a `Handler`.

A `Handler` in Go is a simple interface that represents an object that can deal with - well, handle - an HTTP request:

```golang
type Handler interface {
	ServeHTTP(ResponseWriter, *Request)
}
```

There's only one method on this interface, and so it's common to want to implement it using a simple function:

```golang
func MyHandler (response ResponseWriter, request *Request) {
    // do some work here.
}
```

But to get to the desired interface, we'll need to adapt it.

We could write a more Gang Of Four style Adapter to adapt the function to a `Handler`:

```golang
type HandlerAdapter struct {
    handler func (ResponseWriter, *Request)
}

func (adapter HandlerAdapter) ServeHTTP (response ResponseWriter, request *Request) {
    adapter.handler(response, request)
}

func NewHandlerAdapter(handler func (ResponseWriter, *Request)) MyHandler {
    return HandlerAdapter {
        handler: handler
    }
}
```

Which would let us use an anonymous function as a Handler:

```golang
    var handler Handler = NewHandlerAdapter(MyHandler)
```

But Go provides a neat trick that lets us write an Adapter by using a new type - behold `HandlerFunc`:

```golang
// The HandlerFunc type is an adapter to allow the use of
// ordinary functions as HTTP handlers. If f is a function
// with the appropriate signature, HandlerFunc(f) is a
// Handler that calls f.
type HandlerFunc func(ResponseWriter, *Request)

// ServeHTTP calls f(w, r).
func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request) {
	f(w, r)
}
```

By creating a new type for the handler function, we can add new methods to it - and so we can implement the `Handler` interface directly on the function itself. All we need to do is convert the original type `func(ResponseWriter, *Request)` to the `HandlerFunc` type in order to get the interface we need:

```golang
    var handler Handler = HandlerFunc(MyHandler)
```

Either way would work fine. The key point here isn't the differences between the two implementations: what's important is that they're performing the same role in the code. They're both examples of the Adapter Pattern.

## The Decorator Pattern

### What's The Problem?

> I want to test my program against the real implementations of its dependencies, but I also want to test how it behaves when they error, like I'd do with a stub. I want my cake and I want to eat it.

And with the Decorator Pattern, you can.

### The Pattern

The Decorator Pattern is what you get when you have an object that which performs some action... but you want it to do a little bit more. You don't want the interface to be changed, but you _do_ want that same interface to have a different behaviour.

### Examples

#### `bufio.Reader`

A simple example from the Go standard library is the [`Reader`](https://cs.opensource.google/go/go/+/refs/tags/go1.19:src/bufio/bufio.go;l=32) type from the `bufio` package. The purpose of this type is to add buffering to an `io.Reader`. Here's a look at the internals:

```golang
// Reader implements buffering for an io.Reader object.
type Reader struct {
	buf          []byte
	rd           io.Reader // reader provided by the client
	r, w         int       // buf read and write positions
	err          error
	lastByte     int // last byte read for UnreadByte; -1 means invalid
	lastRuneSize int // size of last rune read for UnreadRune; -1 means invalid
}
```

As you can see there's a lot going on inside that we don't care about. And there's an extensive collection of methods on the `bufio.Reader` type that we also don't care about in this example. Patterns are all about interfaces, and what we _do_ care about is that `bufio.Reader` [implements the `io.Reader` interface](https://pkg.go.dev/bufio#Reader.Read):

```golang
func (b *Reader) Read(p []byte) (n int, err error)
```

Which means that, in terms of the interfaces,  `bufio.Reader` is a Decorator of the `io.Reader` interface, that adds buffering to its behaviour.

### Fault Injection

When testing parts of an application the ideal is always to test using "real" things. Now, I'm not saying that there's not a place for test doubles - I use them all the time. But it can't be denied that what you _really_ want to see when running your automated test is that the thing your testing works with real things.

But here's the problem: you want real things to work, but you also want to test how your program behaves when the real things _don't_ work. This isn't quite as important when you're unit testing individual methods on a stateless object, but it gets a whole lot more important when you're testing the behaviour (one could say the _protocol_, which might mean the object's interface and its interactions with itself and with other interfaces. Which, come to think of it, is 90% of the hard work of testing. But I digress). 

Imagine a situation where three stateful objects with not-insignificant interfaces are interacting with each other a lot. Imagine you're halfway down the sequence diagram of their interactions. Imagine that you want to find out what happens when just _one_ of those interactions fails, what state each of the objects wind up in.[^7]

Here's one of our objects:

```golang
type One interface {
    DoOneThing() error
    DoAnotherThing() error
    OneMoreThing() error
    OkAreWeDoneYet() error
    WowBigInterface() error
}
```

The simplest way to affect the behaviour of just one of those methods is with a Decorator:

```golang
type DecorateOne struct {
    One
}

func (d *DecorateOne) OneMoreThing() error {
    return errors.New("emit macho dwarf: elf header corrupted")
}
```

We embed the interface we're trying to test in our decorator struct, which mean that the struct now implements the same interface, and we then override any of the behaviours we want to control by implementing the methods on the struct.

This is a fairly unsophisticated example, but what you should realise is that, once we've decorated an object, we're in complete control. If we want to spy one the method calls to `One`, we can. If we want to stub out the the third and sixth calls, but send all the others through to the real object, we can. And we can dynamically update the behaviour of the decorator in plenty of different ways to make it reusable:

```golang
type DecorateOne struct {
    One
    DoOneThingFunc func () error
    OneMoreThingFunc func () error
    // etc...
}

func (d *DecorateOne) OneMoreThing() error {
    if d.OneMoreThingFunc == nil {
        return b.One.OneMoreThing()
    }
    return d.OneMoreThingFunc()
}

// and so on for the other methods
```

### Adapter and Decorator: Two Sides of the Same Coin

The Adapter Pattern takes the an object's behaviour and changes its interface by wrapping it in another object.

The Decorator Pattern takes an object's interface and changes its behaviour by wrapping it in another object.

## Facade Pattern

### What's the problem?

### The Pattern

In the Facade Pattern we give ourselves the interface to the object that we want for most use cases, but still allow ourselves access to the underlying object whe we need it. The idea is to simplify the interface, usually through being opinionated about what we want the object to be used for.

### Examples

Lol I don't know right now

Basically, embedding an interface into a struct and writing the methods that you want on it:

```go
type Facade struct {
    FacadedInterface
}
```

One can still access the underlying object:

```go
facade.FacededInterface.DoYourThing()
```

## Abstract Factory

### The Problem


---

[^1]: Not that this is relevant here, but I feel that people take this sgentence too far. It says _favor_ composition, not exclusively use it. I'm one of the few programmers I know who actually _likes_ inheritance, and thinks its a quick and easy and simple way to get code reuse. Whole beautiful systems have been written using inheritance. So, use inheritance. But not in Go, obviously.

[^2]: _Design Patterns: Elements of Reusable Software_ by Gamma, Helm, Johnson & Vlissides, p.20

[^3]: Kotlin, an increasingly popular JVM language that is a superset of Java, makes this almost as easy as Go does through declaring that classes implement an interface by delegating to one of their constructor arguments: `class Derived(b: Base) : Base by b`. See https://kotlinlang.org/docs/delegation.html#overriding-a-member-of-an-interface-implemented-by-delegation

[^6]: _Design Patterns: Elements of Reusable Software_ by Gamma, Helm, Johnson & Vlissides, p.20

[^7]: Of course, you could argue that if you've got your code in this situation then the problem really isn't the test.

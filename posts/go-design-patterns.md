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

When you read the Gang Of Four design patterns book, you really shouldn't skip past the introduction. 


### Interfaces, Not Implementation

> This so greatly reduces implementation dependencies between subsystems that it leads to the following principle of reusable object-oriented design:

> > Program to an interface, not an implementation.

> Don’t declare variables to be instances of particular concrete classes. Instead, commit only to an interface defined by an abstract class. You will find this to be a common theme of the design patterns in this book.

### Composition, Not Inheritance

> Favor object composition over class inheritance

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

A neat trick - and either way would work fine. The key point here isn't the differences between the two implementations: what's important is that they're performing the same role in the code. They're both an example of the Adapter Pattern.

## The Decorator Pattern

### What's The Problem?

> Halp! I've written a JSON API and I need all of my HTTP responses to have a set of standard headers added to them.

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

As you can see there's a lot going on inside that we don't care about. And there's also an extensive collection of methods on the `bufio.Reader` type that we also don't care about in this example. Patterns are all about interfaces, and what we _do_ care about is that `bufio.Reader` [implements the `io.Reader` interface](https://pkg.go.dev/bufio#Reader.Read):

```golang
func (b *Reader) Read(p []byte) (n int, err error)
```

Which means that, in terms of the interfaces,  `bufio.Reader` is a Decorator of the `io.Reader` interface, that adds buffering to its behaviour.

## Adapter and Decorator: Two Sides of the Same Coin

The Adapter Pattern takes the an object's behaviour and changes its interface by wrapping it in another object.

The Decorator Pattern takes an object's interface and changes its behaviour by wrapping it in another object.

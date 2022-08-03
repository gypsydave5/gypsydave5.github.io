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

## Intro

When you read the Gang Of Four design patterns book, you really shouldn't skip past the introduction. Even if you (think) you know how Object

## Adapter Pattern

We want to use Object A in a place where Object B is expected. Object A is functionally equivalent to Object B - but it happens to differ in terms of its interface. This could be as simple as the order of arguments in a method, or the name of some methods. Or it could be a shade more complicated. But not too complicated an adaptation - anything too complicated is really the responsibility of the Bridge Pattern or the Facade Pattern.

The Adapter Pattern is just the way of mapping the interface of A to B. We wrap A up in an object that implements B's interface, translating the method calls (and properties) to the equivalent in A.

### In Go

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

But Go provides a neat trick that lets us write an Adapter by using a type alias - behold `HandlerFunc`

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

By aliasing the type of a handler function to a new type, we can add new methods to it - and so we can implement the `Handler` interface directly on the function itself. All we need to do is convert the original type `func(ResponseWriter, *Request)` to the `HandlerFunc` type in order to get the interface we need:

```golang
    var handler Handler = HandlerFunc(MyHandler)
```

A neat trick - and either way would work fine. The key point here isn't the differences between the two implementations: what's important is that they're performing the same role in the code. They're both an example of the Adapter Pattern in use.

## Decorator Pattern

---
layout: post
title: "`this` is my type"
date: 2022-01-26 19:12:28
tags:
    - TypeScript
published: false
---

Ah man, the shit you can do in TypeScript with `this` as a type. Let me show you:

## `this` as a return type

Who hasn't written something using the builder pattern? Ok, so probably a few of you. The idea is that you construct an object by adding to it incrementally with method calls, then "finalize" it using another method. Like this:

```typescript
    const dog = new DogBuilder().withName('Erik').withWeightKg(15).withCoat(Colors.OrangeRoan).withBreed(Breeds.CockerSpaniel).build()
```

There are benefits, there are downsides, blah blah blah. You might prefer to do the same thing using a configuration object with defaults. Go read and have fun.

Things get interesting on the inside of our `DogBuilder`:

```typescript
class DogBuilder {
    private name = 'Rover';
    private weight = 22;
    private coat = Color.Black;
    private breed = Breeds.Labrador
    
    
    public withName(name :string) {
        this.name = name
        return this
    }
    
    public withWeightKg(weight: number) {
        this.weight = weight
        return this
    }
    
    public withCoat(coat: Colors) {
        this.coat = coat
        return this
    }
    
    public withBreed(breed: Breed) {
        this.breed = breed
        return this
    }
    
    public build(): Dog {
        return new Dog(this.name, this.weight, this.coat, this.breed)
    }
}
```

All good I hope. So what's the return type for each of our methods? Well, pretty obviously it's a `DogBuilder`. We get a builder back each time until we call `build()` - that's how the builder works. We can be explicit about this:

```typescript
class DogBuilder {
    private name = 'Rover';
    private weight = 22;
    private coat = Color.Black;
    private breed = Breeds.Labrador
    
    
    public withName(name :string): DogBuilder {
        this.name = name
        return this
    }
    
    public withWeightKg(weight: number): DogBuilder {
        this.weight = weight
        return this
    }
    
    public withCoat(coat: Colors): DogBuilder {
        this.coat = coat
        return this
    }
    
    public withBreed(breed: Breed): DogBuilder {
        this.breed = breed
        return this
    }
    
    public build(): Dog {
        return new Dog(this.name, this.weight, this.coat, this.breed)
    }
}[ cc[m
m[mm]]]
```

OK - great. Now make me a `PoodleBuilder` for my new `Poodle` class. Poodles come in four sizes: standard, medium, miniature and toy, so add let's have a nice enum for that too. Go on, get on with it. Oh alright, I'll do it.,,,[[]]

Now we could implement this in a few ways, but let's take a look at using _inheritance_ to reduce the code duplication (yes, we could use composition, no we're not going to).

```typescript
class PoodleBuilder extends DogBuilder {
    private name = 'PoPo';
    private weight = 22;
    private coat = Color.Black;
    private breed = Breeds.Poodle
    private size = Size.medium
    
    public withSize(size: Size): PoodleBuilder {
        this.size = size
        return this
    }
    
    public build(): Poodle {
        return new Poodle(this.name, this.weight, this.coat, this.breed, this.size)
    }
}
```

Well now things are going to get interesting.

```typescript
const poodle: Poodle = new PoodleBuilder().withName('Fluffy').withWeightKg(1).withCoat(Colors.White).withSize(Size.toy).build()
```

This will _blow up spectacularly_ when we run the type checker.

```
TS2339: Property 'withSize' does not exist on type 'DogBuilder'
```

and check out:


```typescript
const anotherPoodle: Poodle = new PoodleBuilder().withName('Fluffy').withWeightKg(1).withCoat(Color.White).build()
```

```
TS2741: Property 'size' is missing in type 'Dog' but required in type 'Poodle'.
```

Yeah, that ain't no `Poodle` we got there, that's a `Dog`. And that ain't no `PoodleBuilder` we're getting after `withName()` in the first example, that's a `DogBuilder`. Or at least, that's what the type system thinks. How can we convince it that it's really a `PoodleBuilder`?

We tell it that the return type of the methods in the `DogBuilder` is `this`. Yes - `this`! `this` is a type, and it refers to the type of... well, `this`. At the risk of showing my age, check it out:


```typescript
class DogBuilder {
    private name = 'Rover';
    private weight = 22;
    private coat = Color.Black;
    private breed = Breeds.Labrador
    
    
    public withName(name :string): this {
        this.name = name
        return this
    }
    
    public withWeightKg(weight: number): this {
        this.weight = weight
        return this
    }
    
    public withCoat(coat: Colors): this {
        this.coat = coat
        return this
    }
    
    public withBreed(breed: Breed): this {
        this.breed = breed
        return this
    }
    
    public build(): Dog {
        return new Dog(this.name, this.weight, this.coat, this.breed)
    }
}
```

and all those type issues just melt away!

The `this` type will be inferred - you don't always need to declare it as the return type of a method. But writing it out explicitly can help improve our understanding.

So - what else can we do with `this`?

## `this` as the receiver type

Who hasn't done this:

```typescript
class Dog {
    constructor(public readonly name: string, readonly breed: Breed) {
    }

    sayHello(): string {
        console.log(`Hello, I'm a ${this.breed} called ${this.name}`)
    }
}

const rover = new Dog('Rover', Breed.Poodle)
setTimeout(() => rover.sayHello(), 10)
// => Hello, I'm a Poodle called Rover
```

oh we can just remove that outer function through [eta reduction](https://wiki.haskell.org/Eta_conversion) and it'll do the same thing. Functional programming for the win:


```typescript
setTimeout(rover.sayHello, 10)
// => Hello, I'm a undefined called undefined
```

Curse you `this`! Yeah, this happens to every JavaScript and TypeScript developer - we've lost our binding to the reciever when we passed the function uncalled into `setTimeout`. So now this is `undefined`.

How can we fix this? Well, that's also one of the first things you will work out: you use `bind()`:

```typescript
setTimeout(rover.sayHello.bind(rover))
// => Hello, I'm a Poodle called Rover
```

Beautiful, all fixed, well done everyone. But how can we avoid having the problem in the first place? How can we make sure that the function always has the correct `this` context when it's executing?

Well, it's not going to be too much of a surprise given the title of this article, so here's what it looks like anyway:

```typescript
class Dog {
    constructor(public readonly name: string, readonly breed: Breed) {
    }

    sayHello(this: Dog): string {
        console.log(`Hello, I'm a ${this.breed} called ${this.name}`)
    }
}
```

Yeah, so there you go. The `this` pseudo parameter that makes you feel like you're writing Python, or Go, or Rust, or some other superior language. Yay.

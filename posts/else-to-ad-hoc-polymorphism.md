---
title: Replace `when` with Function Overloading
description: Need a Union in Kotlin? Try this.
published: true
date: 2024-09-06 22:52:55
tags:
- kotlin
- patterns
---

Sometimes I want a Union type of two types in Kotlin - but I can’t. Kotlin has no Union type.

Usually this can be avoided, if you have control over your types, with a [Sealed Class](https://kotlinlang.org/docs/sealed-classes.html). But if your type hierarchy has to be open, you don’t have that option.

Say we wanted a function that feeds my pet:

```kotlin
fun feedMyPet(pet: Animal)
```

But, sadly, `Animal` is not a sealed class. Tragically, we don't own it. And, even worse, there’s no unified interface for feeding.

If I’ve got a `Dog`:

```kotlin
class Dog : Animal {
	fun fillUpTheDogFoodBowl()
}
```

And a `Fish`:

```kotlin
class Fish : Animal {
	fun sprinkleFishFoodOnTheTank()
}
```

Then the implementation of `feedMyPet` becomes harder. We can do it with a type switch:

```kotlin
fun feedMyPet(pet: Animal) {
	when (pet) {
		is Fish -> pet.sprinkleFoodOnTheTank()
		is Dog -> pet.fillUpTheDogFoodBowl()
		else -> error("I don't know how to feed a ${pet::class}")
	}
}
```

But the problem here is that I would like callers of `feedMyPet` to know that it can only work with a `Fish` or a `Dog`. I don’t want them to be surprised by runtime errors when they try to feed an `Iguana`:

```kotlin
val ivanTheIguana = Iguana()

feedMyPet(ivanTheIguana)
// => "I don't know how to feed a Iguana"
```

In other languages, we could introduce a union type - `Fish | Dog` - to limit the types that `feedMyPet` would accept. But Kotlin does not currently support union types.

One solution would be to create my own sealed class to represent the pets that I own:

```kotlin
sealed class MyPet
class MyDog(val dog: Dog) : MyPet
class MyFish(val fish: Fish): MyPet
```

Which would then let us get rid of the `else` clause.

```kotlin
fun feedMyPet(pet: MyPet) {
	when (pet) {
		is MyFish -> pet.fish.sprinkleFoodOnTheTank()
		is MyDog -> pet.dog.fillUpTheDogFoodBowl()
	}
}
```

Or even better:

```kotlin
sealed class MyPet {
  fun feed()
}

class MyDog(private val dog: Dog) : MyPet {
	fun feed() = dog.fillUpTheDogFoodBowl()
}

class MyFish(private val fish: Fish): MyPet {
  fun feed() = fish.sprinkleFoodOnTheTank()
}

fun feedMyPet(pet: MyPet) {
	pet.feed()
}
```

But this might not be the nicest interface to use: 

```kotlin
val freddyTheFish = Fish()
val duncanTheDog = Dog()

feedMyPet(MyFish(freddyTheFish))
feedMyPet(MyDog(duncanTheDog))
```

If I’m having to wrap my `Dog` or `Fish` every time I want to `feedMyPet`, I’m going to get annoyed.

Now, maybe this is a _good thing_. Perhaps we’re being told that  we need a new abstraction, a representation of ‘pet types that I own’ that doesn’t leak the types of `Animal` all over the code.

In the case of domain types (yes, like `Cat` and `Fish` here), we should take the hint and start only using `MyPet`s everywhere.

But what if this was more incidental code that I needed to call on an ad-hoc basis? If the only time I care about `MyPet` is when I’m feeding it, but for the rest of the `Animal`s life it just gets treated as an `Animal`, `MyPet` is then an irritant in the `feedMyPet` interface.

My preferred solution would be to use [ad-hoc polymorphism](https://en.wikipedia.org/wiki/Ad_hoc_polymorphism), namely [function overloading](https://en.wikipedia.org/wiki/Function_overloading):

```kotlin
fun feedMyPet(fish: Fish) {
	fish.sprinkleFoodOnTheTank()
}

fun feedMyPet(dog: Dog) {
	dog.fillUpTheDogFoodBowl()
}
```

This is definitely _ad-hoc_ polymorphism - if I saw myself repeating this pattern more than once I’d most likely replace it with the sealed class.

But, when that seems like overkill, it’s a good pattern.
---
title: "Functors, Applicatives, and Monads: A Tale of Shape"
date: 2025-12-19 00:00:00
published: false
description: "Understanding the difference between Functors, Applicatives, and Monads through the lens of shape preservation and transformation."
tags:
  - functional programming
  - haskell
  - type theory
  - monads
---

I was ~~forced~~ persuaded to take a few ~~minutes~~ hours out of my busy schedule to talk to one of our very smart senior developers about what an applicative was today. Well, bad news for her - I am _terrible_ at functional programming. I had no pat answer to offer, no beautiful category theory to wave around. But we did have an hour to kill, and it was nearly Christmas, so we treated ourselves to working it out between us.

Now, obviously, a lot of work went on. A lot of talking slowly. A _lot_ of saying functor when we meant applicative (mainly me). But I got quite excited at the end because we ended up with something that I actually understood. And so here it is.

First, let's talk about _shapes_.

## What is "Shape"?

Because we're talking about this exciting functional programming stuff, let's just bite the bullet and use Haskell as the example. Go learn Haskell now and come back in a few years. Kidding, kidding - we'll try to keep it light.

First, we'll need one of these "wrapper" types - my colleague calls them "boxes", I sometimes hear "container" or "context". Let's pick all time favourite `Maybe`.

`Maybe` gives context to a value - it says it might not be there. It's "generic" in Java-speak, in that it could be a `Maybe` of a few different types - `Maybe Int` or `Maybe String` etc.

`Maybe` isn't concrete - it comes in two flavours: `Just a` and `Nothing`. `Just a` is what you've got if you actually have something (an `a` in this case), and `Nothing` is what you've got when you've got nothing.

So

```haskell
x :: Maybe Int
x = Just 5
```

and also

```haskell
x :: Maybe String
x = Nothing
```

Go read some Haskell if you want more, and how to define your own `Maybe` type. It's fun!

So I'd like you to think of `Maybe` as coming in two shapes. Let's say that `Just` is a nice square, and `Nothing` is a triangle. Obviously, `Just` is a box - a container - with an `a` inside it - an `Int` or whatever.

So, with shapes, the above two expressions look like this:

![Maybe shapes](../images/maybe-shapes.svg)

Good fun. So what can we do with `Maybe`

## Level One: Functor - Shape Stays the Same



One of the things we want to do with our context boxes is to change the thing that's inside them. We do this by letting our boxes be _functors_. What does that mean? It means that they let you give them a function that turns the value inside into something else.

For instance, if I've got `Just 5` and I want to add `2`, if `Maybe` is a functor, I can just hand over the magic `+2` function and I'll get ... well, will I get 7 back? No. Because if `Maybe` is a functor I also need to handle the case where I try to hand over `+2` to `Nothing`. Which just doesn't work. What do I get if I `+2`  `Nothing`? Well, I get `Nothing` - nothing will come of nothing.

In Haksell, this "letting you give them a function" is a **type class**. We can think of this as being an interface that a type can implement. The type class for functor has just the one function:

```haskell
fmap :: (a -> b) -> Maybe a -> Maybe b
```

Which just says this

> `fmap` takes a function that turns an `a` into a `b` , then takes a `Maybe a` and will give you a `Maybe b`

In our case `a` and `b` are both `Int`, but you should now see where this goes

```haskell
fmap (+2) -> Just 5 -> Just 7
```

and

```haskell
fmap (+2) -> Nothing -> Nothing
```

The rule here is that if you "do a functor" (use `fmap`) with a `Maybe`, then your output types will look like this:

```
Nothing -> Nothing

Just -> Just
```

With our shapes, it looks like this:

![Functor preserves shape](../images/functor-shape-preserved.svg)

and this leads us to the first key observation

> With a functor, the type that comes out is always the same as the type that goes in
>
> Or, you know, if you give it a triangle, you always get a triangle back, and same for squares

### Level Three: Monad - Shape Depends on Values

Wait, what - level three? Yeah, level three. We'll skip to the end because applicatives actually fit neatly between functors and monads. But because most people (have to) understand monads from the beginning, we'll go here first and work backwards.

So if we've got a type that represents a case where something might not be there - our `Maybe a` - we can imagine a type of function that returns it. When might we perform an operation that might not give us a result?

The classical example is division. Divide 10 by 2, and you get 5. Nice. Divide 10 by 0 and you get... what? I don't know. So we know that some numbers will work, and at least one won't - zero.[^1]

We can represent the ones that don't work with `Nothing` and the ones that do with `Just Int` - and blow me down if that's not what the good Haskell folk did:


```haskell
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv x y = Just (x `div` y)

safeDiv 10 2  -- Just 5
safeDiv 10 0  -- Nothing
````

Which is just a way of saying, if you try to divide anything by 0, you're going to get `Nothing`.

Making a type into a monad is just a case of giving it ~~an interface~~ a type class that lets you do what you were doing with functors, but instead of giving a function that goes from `a -> a` , we want to pass one of our functions that return the ~~functor~~ monad type - so `a -> m a`. In the case of `Maybe` that would be either `a -> Maybe a`.[^2]

And in Haskell, this type class looks like this when added to `Maybe`:

```
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
```

 `>>=` is just an infix function we can use like an operator - and it just happens to take the  value being worked on as its first argument, rather than as its second in the case of `pmap`.

Now here's the fun bit. The type that pops out at the end of the calculation can depend on _both_ the type of the first value that goes in (the first `Maybe a` above), _and_ the value of `a` when it gets transformed by our function - `a -> Maybe b`.

For the first example, let me tell you that `Nothing` behaves the same way as our `Nothing` functor - nothing will come of nothing. So any use of `(>>=)` with `Nothing` will always go something like this:

```haskell
Nothing >>= \x -> if x > 3 then Just (x*2) else Nothing -- Nothing
```

Whatever function you give to `(>>=)`, if the value on the left is `Nothing` you will always get `Nothing`.

But, if it's `Just a` , well - you just can't tell without looking at the functions you're passing to `(>>=)`

```haskell
Just 5 >>= \x -> if x > 3 then Just (x*2) else Nothing  -- Just 10
```

```haskell
Just 2 >>= \x -> if x > 3 then Just (x*2) else Nothing  -- Nothing
```

Drawing our shapes again, we get:

![Monad value-dependent shape](../images/monad-value-dependent.svg)



The insight here is this:

> with monads, you cannot tell just from the context what the output is going to be; you need to look at the values too.
>
> or, in other words, if you've got a square (or a triangle), then you can't tell what shape you're going to get out at the end of the calculation without opening the box



## Level Two: Applicatives - Shape Depends on Shape

And so we come finally to applicatives (more formally, applicative functors) - the middle ground between functors and monads.

- Functor: Context Remains The Same
- **Applicative: Context Depends on Context**
- Monad: Context Depends on Context _and_ Value

The implementationa of the applicative type class in Haskell for `Maybe` looks like this:

```haskell
(<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
```

which is _maybe_ not what you were expecting. It wasn't what I was expecting either. The twist here is that the _function itself is in a context_. It's not just `a -> Maybe b` as with the monads - it's `Maybe (a -> b)`. Hopefully that will make more sense towards the end.

Let's start with a simple example. A function that adds 3 to any number - which in Haksell we can write as `(+3)`. To "raise" this into the `Maybe` context (wrap it in a box) we can just (ahahaha) `Just (+3)`.

The next step, hand over a `Just 5` and you'll get a `Just 8`:

```haskell
Just (+3) <*> Just 5 -- Just 8
```

But what if it's not `Just 5` - what if it's `Nothing`? Or what if we don't have a `Just (+3)` in the first place - what if that's `Nothing` too? Once again, nothing will come of nothing - and so any calculation with `Nothing` in its arguments will result in `Nothing`

```haskell
Just (+3) <*> Nothing -- Nothing

Nothing <*> Just 5 -- Nothing
```

What we end up here is a kind of "closed" algebra:

```
Just -> Just -> Just
Nothing -> Just -> Nothing
Just -> Nothing -> Nothing
Nothing -> Nothing -> Nothing
```



with our shapes, it looks like this

![Applicative shape algebra](../images/applicative-shape-algebra.svg)

and so we reach our final insight

> with applicatives, the context of the output is entirely determined by the context of the inputs
>
> or, in other words, if you know the shapes going in, you know the shape coming out

and so we have a nice hierarchy

> Functor - the context type remains constant
>
> Applicative - the context of the output is a function of the contexts of the inputs
>
> Monad - the context of the output is a function of the contexts _and_ values of the inputs

Great! A good answer to _what_ is an applicative. Now - _why_?

## Why bother with any of this?

Indeed.

## The Soul Of Iteration

What even is "iteration"? Reaching for a nice sensible imperative language, we have something like this:

```javascript
// Transform each element (mapping)
const numbers = [1, 2, 3];
const doubled = [];
for (const n of numbers) {
    doubled.push(n * 2);
}
// doubled = [2, 4, 6]
```

```javascript
// Combine elements into a single value (folding)
const numbers = [1, 2, 3];
let sum = 0;
for (const n of numbers) {
    sum = sum + n;
}
// sum = 6
```

But then there's this one - which is not quite like the others:

```javascript
// Do something with side effects for each element
const users = [user1, user2, user3];
for (const user of users) {
    console.log(`Processing user: ${user.name}`);
}
```

or even

```javascript
const users = [user1, user2, user3];
for (const user of users) {
  if (user.bad()) throw new UserError(user);
}
```

For the first two, we're collecting some sort of result - either the list we've mapped over, or the value we've accumulated (folded) together.

But the last two have effects - the first prints, the second errors.

In Haskell, we describe these sort of side-effects using data types - things like `IO` or `Either` or `Maybe`.    We don't want - we can't let - anything "escape" from these types.

So what does iteration look like here? In order to cover the final two examples we need

- to take some iterable data structure
- for each item, we do a thing to it that (may) produce a result and some context representing a side effect (or no side effect)
- do something with all those results and side effects so that we get _one_ result and _one_ side effect.

Now that last point should seem spookily identical to our definition of an `Applicative` - a group of values in contexts that can be combined with each other.



```haskell
 class (Functor t, Foldable t) => Traversable t where
       traverse :: Applicative f => (a -> f b) -> t a -> f (t b)
```

The superclasses are required here to say that if something is `Traversable` then it is also a `Functor` and `Foldable`. [^3]





### Validating Input

Say you're building a user registration form. You want to validate the name, email, and age - and if anything's wrong, you want to show the user **all** the errors at once, not just the first one.

With monads, you stop at the first failure:

```haskell
validateUser :: String -> String -> Int -> Either String User
validateUser name email age = do
    validName  <- validateName name      -- Stops here if invalid
    validEmail <- validateEmail email    -- Never checked if name fails
    validAge   <- validateAge age        -- Never checked if above fail
    return $ User validName validEmail validAge
```

But with applicatives (using a `Validation` type that accumulates errors):

```haskell
validateUser :: String -> String -> Int -> Validation [String] User
validateUser name email age = User
    <$> validateName name
    <*> validateEmail email
    <*> validateAge age
```

Now all three validations run independently, and you collect **all** the errors:

```
validateUser "" "not-an-email" (-5)
-- Failure ["Name cannot be empty", "Invalid email format", "Age must be positive"]
```

The applicative version makes it clear that these validations are **independent** - none depends on the results of the others. And because the structure is static, a validation library can ensure all checks run before returning.

### Parsing Form Data

Or say you're parsing form data from an HTTP request - you need to extract several fields and construct an object:

```haskell
data CreatePost = CreatePost
    { title :: String
    , body :: String
    , tags :: [String]
    }

-- Monadic approach - sequential, stops at first missing field
parsePost :: FormData -> Maybe CreatePost
parsePost form = do
    title <- lookup "title" form
    body  <- lookup "body" form
    tags  <- lookup "tags" form >>= parseTags
    return $ CreatePost title body tags
```

With applicatives:

```haskell
parsePost :: FormData -> Maybe CreatePost
parsePost form = CreatePost
    <$> lookup "title" form
    <*> lookup "body" form
    <*> (lookup "tags" form >>= parseTags)
```

Or even cleaner with helper functions:

```haskell
parsePost :: FormData -> Maybe CreatePost
parsePost form = CreatePost
    <$> getField "title" form
    <*> getField "body" form
    <*> getFieldAndParse "tags" parseTags form
```

The applicative style makes the **shape** of your parser clear - "I need three fields to construct a CreatePost". With the monadic version, that structure is hidden in the sequencing. This static structure is valuable:

- You could generate documentation: "This endpoint requires: title, body, tags"
- You could validate the form structure before processing
- The code reads like the data structure it's building



[^1]: Fancy folk will call this a partial function, and sneaking our `Maybe` in will make it total. But we don't have to get fancy.
[^2]: Observant  readers who have played around with lists will realise that, when dealing with a list, `pmap` is what we'd call `map `
[^3]: Concretely, that we can define `fmap` (for `Functor`) and `foldMap` (for `Foldable`) using `traverse`:
```haskell
fmap :: Functor t => (a -> b) -> t a -> t b
fmap f = runIdentity . traverse (Identity . f)
```
```haskell
foldMap :: (Foldable t, Monoid m) => (a -> m) -> t a -> m
foldMap f = getConst . traverse (Const . f)
```
So anything that is `Traversable` is, in fact, both a `Functor` and `Foldable`. All we're doing by mentioning them here is making sure that when we implement `Traversable` we remember , and keeping things consistent - it would be irritating for something to be `Traversable` but not `Foldable` or a `Functor`.
As to why `foldMap` is sufficient for `Foldable`, and why it needs a `Monoid` - I feel that's another blog post.



---

### Notes

##### other applicatives

List (cartesian product)

```haskell
     [(+1), (*2)] <*> [1, 2, 3]  
     -- [2, 3, 4, 2, 4, 6]
     -- Shape: n functions × m values = n*m results
     
     [1, 2] <*> [10, 20, 30]  -- using as function list
     -- Wait, needs functions...
     
     -- Better:
     pure (+) <*> [1, 2] <*> [10, 20]
     -- [11, 21, 12, 22]
     -- 2 × 2 = 4 combinations
```



##### Notes

The Key Difference You Identified

**Applicative:**

```haskell


-- You can analyze the computation structure without running it

analyze :: Applicative f => f a -> f b -> f c -> Structure

analyze fa fb fc = "Will combine 3 effects in parallel"

   

-- Example: can count effects, optimize, parallelize

sequence [Just 1, Just 2, Just 3] -- Known to be Just [1,2,3] or Nothing
```
**Monad:**

```haskell
   -- You CANNOT know the structure without running it

mystery :: Maybe Int -> Maybe String

mystery x = x >>= \val ->
​ if val > 5 
​  then Just (show val) >>= \s -> 
​     if length s > 2 then Nothing else Just s
​  else Nothing

-- The shape depends on the VALUE of x
mystery (Just 4)  -- Nothing
mystery (Just 6)  -- Just "6"
mystery (Just 100) -- Nothing (string too long)
```


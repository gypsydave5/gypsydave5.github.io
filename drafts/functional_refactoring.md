# Four Functional Refactors

These are the four functional refactoring that Jim Weirich lists while
demonstrating a a derivation of the Y-combinator in Ruby. It's a great video
- well worth a watch. I'll pop it at the end of this article if you've got the
time to enjoy it.

Refactors like these help to restructure your code to allow you to introduce new
behaviours,

I find it useful having these refactors in my head when working. Maybe you will
too!

### 1. Tennant Correspondence Principle ###

Originally based on an observation about languages, this 'principle' states that
wrapping any expression in a lambda that returns that expression will act in the
same way as the expression itself.

For instance, here's a lambda that doubles a number:

```javascript
n => n + n
```

```javascript
(n => n + n)(2)
// 4
```

If we wrap it in another lambda...

```javascript
() => n => n + n
```

... then calling it will return the original lambda...

```javascript
(() => n => n + n)()
```

Which behaves in the same way as the original expression.

```javascript
(() => n => n + n)()(4)
// 8
```

### 2. Introduce a Binding ###

Taking a similar situation as above, here we have the same function wrapped in
a lambda:

```javascript
(() => n => n + n)()
// n => n + n
```

We can introduce a binding to the outer lambda without affecting the lambda that
is returned...

```javascript
(bob => n => n + n)(22)
// n => n + n
```

... which can then be called - the '22' has no effect on any result.

```javascript
(bob => n => n + n)(22)(8)
// 16
```

We don't even have to be too careful about the binding's name if it's unused in
the inner lambda - the variable just gets rebound.

```javascript
(n => n => n + n)(22)(8)
// 16
```

But this is _maybe_ not the best idea for readability...

We could also add an extra binding to the double function itself, as long as we're
happy to call it with an extra argument:[^1]

```javascript
((n, bob) => n + n)(8, 'blah')
// 16
```

### 3. η-conversion ###

I'm calling this one "η-conversion" as that's the name it has as one of the
three basic reductions in the Lambda calculus. But it could easily be called
'wrap function', which is what Jim does.

Here's our double function again:

```javascript
n => n + n
```

Let's wrap it up in another lambda - and bind a variable to it. But now let's
use that variable to call the inner lambda:

```javascript
(a => (n => n + n)(a))
```

The outer lambda now has the same behaviour as the inner lambda - when we call
the outer lambda with parameter, it's carried through and used to call the inner
lambda:

```javascript
(a => (n => n + n)(a))(8)
// 16
```

The behaviour of the code remains the same - and so we have a true refactoring.

### 4. Inline Definition ###

We're going to name a couple of lambdas this time. The doubler is back again,
but let's also have a lambda that adds one to its argument:

```javascript
const doubler = n => n + n
const addOne = n => n + 1
```

We can run them together as you'd expect:

```javascript
doubler(addOne(3))
// => 8
```

Inline definition, in this case, means that we can... well, inline the
definitions of each of the lambdas and preserve the behaviour of the expression.
So we can start by inlining the definition of `doubler`:

```javascript
(n => n + n)(addOne(3))
// 8
```

And then do the same with `addOne`:

```javascript
(n => n + n)((n => n + 1)(3))
// 8
```

The behaviour is preserved - a true refactoring.

## Flip Mode

Remember you can always flip these refactorings around - inlining becomes
extraction, you can remove bindings as well as add them, you can unwrap
functions as well as wrap them. As long as you stick to these patterns you can't
change the way your code behaves.


[^1]: Of course, in JavaScript we can get away with just ignoring the second argument and calling anonymous function with one argument, but this won't work with most languages.

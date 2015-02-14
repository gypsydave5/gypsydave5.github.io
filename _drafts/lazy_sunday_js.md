I've been seeking out more functional JavaScript ideas since I started to get
addicted from my exposure to [the `bind()` function]. My next 'conquest' has
been **lazy evaluation**.

Calculations take time and resources. For instance, if I needed to know what
`4719340 + 397394` was (and I didn't have a calculator), it would take a few
minutes to work out. Right now as I'm typing this, I don't need to know.
Maybe I'll never need to know. I could put those two
numbers and the `+` sign on a piec of paper, stick it in my pocket and, if ever
I needed or was curious/bored enough to know the answer, I could get the paper
out. I could write 'Answer to silly blog sum' on the top of the paper so I could
know what the paper is for.

That's lazy evaluation - hold on to an expression and only evaluate it when you
need to use it. It pairs with **memoization** - keeping the results of evaluated
expressions handy so that you don't have to evaluate them everytime you need
their result.

(Which figures as, if I ever do work out what `4719340 + 397394` is, I never
want to work it out again.)

So let's take a look at a piece of lazy evaluation in JavaScript. Say we have
a simple function:

```javascript
function add (a, b) {
  return a + b;
}
```

And we'd like to make that function lazy - with another function, naturally.
Something like:

```javascript
var addThisLater = lazyEval( add, 4, 5 );

addThisLater() //=> 9
```

`lazyEval()` takes a function name, some more arguments, and returns a function
that, when it evaluates, returns the result of evaluating the passed in function
with the other arguments.

So far so good - but what needs to go inside `addThisLater()` to make it work as
above. As it turns out, not much:

```javascript
function lazyEval (fn) {
  return fn.bind.apply(fn, arguments);
}
```

And this is where things get exciting. We've [seen `bind()` before], so let's
take a look at `apply()`, what happens when we chain it with `bind()`, and
what's happening with `arguments`.

[`apply()`] is pretty simple - it's a method of a function that, when evaluated,
returns the result of evaluating the function with the scope of the first
argument (just like `bind()`). The second argument is an array (or an array-like
object) of arguments to evaluate the the function with. Which all sounds scary,
but if I do this:

```javascript
add.apply(this, [ 1, 2 ]) //=> 3
```

I hope that makes more sense.

[`arguments`] is an array-like object (and you can just read about that
yourself) which contains, unsurprisingly, all of the arguments passed to the
current function you're in. In the above example, when `apply(fn, arguments)` is
evaluated, its passing the arguments `fn, 4, 5` along to the function `apply()`
is being called on. Namely, in this case, `bind()`.

(As a counter example, if `apply()` was replaced by it's close cousin, [`call()`],
which takes more traditional looking arguments, it would look like this:
`bind.call(fn, fn, 4, 5)`)

`fn, 4, 5` gets passed along to `bind()`, where `fn` becomes the `this`
argument, providing the scope, and the `4, 5` get bound to the arguments of the
function that `bind()` is being called on (in our examples, `add()`). And so we
get the add function back with all its arguments bound, ready to be evaluated
with a flick of our `()`.

[`apply()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply
[`arguments`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments
[`call()`]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call

### 1. Tennant Correspondence Principle ###

Originally based on an observation about languages, this 'principle' states that
wrapping any expression in a lambda that returns that expression will act in the
same way as the expression itself.

For instance, here's a lambda that doubles a number:

```lisp
(lambda (n) (+ n n))
```

```lisp
((lambda (n) (+ n n)) 2) ; => 4
```

If we wrap it in another lambda...

```lisp
(lambda () (lambda (n) (+ n n)))
```

... then calling it will return the original lambda...

```lisp
((lambda () (lambda (n) (+ n n)))) ; => (lambda (n) (+ n n))
```

Which behaves in the same way as the original expression.

```lisp
(((lambda () (lambda (n) (+ n n)))) 4 ) ; => 8
```

### 2. Introduce a Binding ###

Taking a similar situation as above (but now in Clojure), we here we have the
same function wrapped in a lambda:

```clojure
((fn [] (fn [n] (+ n n)))) ; => (fn [k] (+ n n))
```

We can introduce a binding to the outer lambda without affecting the lambda that
is returned...

```clojure
(fn [bob] (fn [n] (+ n n)) 22) ; => (fn [n] (+ n n))
```

... which can then be called - the '55' has no effect on any result.

```clojure
(((fn [bob] (fn [n] (+ n n))) 55) 8) ; => 16
```

We don't even have to be too careful about the binding's name if it's unused in
the inner lambda - the variable just gets rebound.

```clojure
(((fn [n] (fn [n] (+ n n))) 55) 8) ; => 16
```

### 3. Wrap Function ###

Here's our favourite <del>lambda</del> anonymous function again, this time
in JavaScript:

```javascript
function (n) { return n + n }
```

Let's wrap it up in another lambda - and bind a variable to it. But now let's
use that variable to call the inner lambda:

```javascript
function (n) { return function (n) { return n + n }(n) }
```

The outer lambda now has the same behaviour as the inner lambda - when we call
the outer lambda with parameter, it's carried through and used to call the inner
lambda:

```javascript
function (n) { return function (n) { return n + n }(n) }(8) // => 16
```

The behaviour of the code remains the same - and so we have a true refactoring.

### 4. Inline Definition ###

Finally, here's Ruby's lambda syntax given a quick workout. We're going to name
a couple of lambdas this time. The doubler is back again, but let's also have
a lambda that adds one to its argument:

```ruby
doubler = ->(n) { n + n }
addOne = ->(n) { n + 1 }
```

We can run them together as you'd expect:

```ruby
doubler.(addOne.(3)) # => 8
```

Inline definition, in this case, means that we can... well, inline the
definitions of each of the lambdas and preserve the behaviour of the expression.
So we can start by inlining the definition of `doubler`:

```ruby
->(n) { n + n }.(addOne(3) # => 8
```

And then do the same with `addOne`:

```ruby
->(n) { n + n }.(->(n) { n + 1 }.(3)) # => 8
```

The behaviour is preserved - a true refactoring.

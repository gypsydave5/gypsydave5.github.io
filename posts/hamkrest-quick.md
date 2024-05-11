---
title: A Quick Guide to Hamkrest
description: A short description of the built in matchers, along with a guide to how I write custom matchers.
published: true
date: 2024-04-21 22:52:55
---

[Hamkrest](https://github.com/npryce/hamkrest) is a Kotlin implementation of the long-in-tooth-but-widely-revered assertion library [Hamcrest](https://hamcrest.org/).

## Who is this for?

This is aimed more at developers who have never used Hamkrest or Hamcrest and want to ~leverage its expressive power~ write tests that read nice.

## The basics

Hamkrest assertions take the following form:

```
<T> assertThat(actual: T, criteria: Matcher<T>)
```

- You always start with the `assertThat` function.
- The first argument is the test subject, the thing you want to assert about.
- The criterial is a matcher - this is the exciting bit where we assert things about the subject.

We’ll look at the built in matchers that you can use out of the box, then how to build matchers of your own.

## Built in Matchers

The matchers that come out of the box. Probably the most useful is:


### `equalTo`

```
assertThat("one", equalTo("two"))
```

```
expected: a value that is equal to "two"
but was: "one"
```

`equalTo` is a simple matcher. It just asserts that the subject is equal to some value. It’s a good start.

## Not

Matchers in Hamkrest can be inverted to their opposite by using the `.not()`, which in Kotlin is also the operator `!`.

```
assertThat(true, !equalTo(true))
```

```
expected: a value that is not equal to true
but is equal to true
```

This will work with all the following matchers.

### `greaterThan`, `lessThan` and other comparables

```
assertThat(1, greaterThan(2))
```

```
expected: a value that is greater than 2
but was: 1
```

`greaterThan` has its counterpart in `lessThan`, and their `lessThanOrEqualTo` and `greaterThanOrEqualTo` versions.

There’s also `isWithin`, that works on a `Range`:

```
assertThat(2, isWithin(3..7))
```

```
expected: a value that is within 3..7
but was: 2
```

### `isA`

`isA` is what you use to assert on the type of the subject:

```
assertThat(2, isA<String>())
```

```
expected: a value that is a kotlin.String
but was: a kotlin.Int
```

`isA` is a bit odd as it takes its argument as type argument. I have forgotten this a number of times to my embarrassment.

### `throws`

```
val thrower = { throw IllegalArgumentException() }
assertThat(thrower, throws<OutOfMemoryError>())
```

```
expected: a value that throws java.lang.OutOfMemoryError
but threw java.lang.IllegalArgumentException
```

`throws` has much in common with `isA`, in that you can assert on the type by passing a type argument to the matcher function. But what if you wanted to assert something about the error message? This is where you will need _higher order matchers_ - matchers that take matchers as arguments.

## Higher-order Matchers

### `throws`

```
val thrower = { throw IllegalArgumentException("bad argument") }
        
assertThat(thrower, throws(equalTo(IllegalArgumentException("terrible argument"))))
```

```
expected: a value that throws IllegalArgumentException that is equal to IllegalArgumentException: terrible argument
but was: IllegalArgumentException: bad argument
```

In this second example of `throws`, we pass another matcher as an argument to the `throws` matcher - in this case `equalTo`. This matcher is then applied to the error that gets thrown.

Think of it as applying another assertion after the more basic one of type - we expect the error to be of _this_ type, and to be `equalTo` _this_ error.

Higher order matchers let us compose new matchers. For instance:

### `hasSize`

```
val list = listOf(1, 2, 3)
assertThat(list, hasSize(equalTo(1)))
```

```
expected: a value that has size that is equal to 1
but had size that was: 3
```

On first glance this may seem unnecessarily verbose: why not just have something like `hasSize(1)` and be done with it? But a higher-order matcher lets us be a bit more refined with our assertions:

```
assertThat(list, hasSize(greaterThan(5)))

assertThat(list, hasSize(lessThan(2)))

assertThat(list, hasSize(isWithin(20..30)))
```

We can now reuse the assertions we’d used on integers[^1] to assert different things about a list’s size.

## Collection Matchers

There are more useful matchers available on collections

### `anyElement`

```
val list = listOf(1, 2, 3)
assertThat(list, anyElement(lessThanOrEqualTo(0)))
```

```
expected: a value that in which any element is less than or equal to 0
but was [1, 2, 3]
```

Here we can assert that at least one element in a collection should match the matcher we pass in.

There is of course the complementary...

### `allElements`

```
val list = listOf(1, 2, 3)
assertThat(list, allElements(greaterThan(1)))
```

```
expected: a value that in which all elements is greater than 1
but was [1, 2, 3]
```

A shorthand for saying `anyElement(equalTo(...))` is `hasElement`

### `hasElement`

```
val list = listOf("one", "two", "three", "four")
assertThat(list, hasElement("five"))
```

```
expected: a value that contains "five"
but was ["one", "two", "three", "four"]
```

There’s also a matcher that asserts the inverse - that the test subject should be one of the values in a collection:

### `isIn`

```
val list = listOf("one", "two", "three", "four")
assertThat("five", isIn(list))
```

```
expected: a value that is in ["one", "two", "three", "four"]
but was not in ["one", "two", "three", "four"]
```

There is a varargs version too.

### `isEmpty`

```
val list = listOf('a', 'b', 'c', 'd', 'e', 'f', 'g')
assertThat(list, isEmpty)
```

```
expected: a value that is empty
but was: [a, b, c, d, e, f, g]
```

`isEmpty` does what you’d expect. What’s nice about it is that it’s an example that takes _no_ arguments - it doesn’t need them.

## String Matchers

Hamkrest has a useful set of matchers around strings. The key thing to remember about the string matchers is that they subtype `Matcher<T>` with `StringMatcher`, which has methods on it to switch between the case sensitivity of the matcher - `caseInsensitive()` and `caseSensitive()`.

### `contains` / `matches`

Both of these behave in the equivalent way to [`CharSequence.contains`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/contains.html) and [`CharSequence.matches`](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.text/matches.html) respectively.

Don’t be like me and use `contains` on lists.

```
val string = "something to do with a fox"
assertThat(string, contains(Regex("lazy dog")))
```

```
expected: a value that contains lazy dog
but was: "something to do with a fox"
```

`matches` needs the RegEx to match the _whole_ string:

```
val string = "something to do with a fox"
assertThat(string, matches(Regex("a fox")))
```

```
expected: a value that matches a fox
but was: "something to do with a fox"
```

If you want to see if a string contains another string you probably want:

### `containsSubstring`

```
val string = "something to do with a fox"
assertThat(string, containsSubstring("A FOX"))
```

```
expected: a value that contains substring "A FOX"
but was: "something to do with a fox"
```

We can make the matcher case insensitive like so:

```
assertThat(string, containsSubstring("A FOX").caseInsensitive())
```

Which would make the test pass.

On the subject of case insensitivity:

### `equalToIgnoringCase`

This is just a nice way of asserting case-insensitive string equality:

```
val string = "hello"
assertThat(string, equalToIgnoringCase("HELLOOO"))
```

```
expected: a value that is equal (ignoring case) to "HELLOOO"
but was: "hello"
```

### `endsWith` / `startsWith`

These two shouldn’t be too surprising. First `startsWith`:

```
val string = "something to do with a fox"
assertThat(string, startsWith("dog"))
```

```
expected: a value that starts with "dog"
but was: "something to do with a fox"
```

And `endsWith`:

```
val string = "something to do with a fox"
assertThat(string, endsWith("dog"))
```

```
expected: a value that ends with "dog"
but was: "something to do with a fox"
```

### `isBlank` / `isNullOrBlank`

These two test whether the string is empty, has only whitespace characters (or is `null` in for the last one).

### `isEmptyString` / `isNullOrEmptyString`

And these two test whether the string is empty (or, again, is `null` for the last one).

## Making your own matchers
\
### Theory: Why bother?

So why would you even want to make your own matchers for Hamkrest? 

In order to have a domain-specific (testing) language to test _your_ domain.

For example, the increasingly-popular Kotlin HTTP library Http4k comes bundled with a selection of Hamkrest matchers for asserting on its domain - the domain of HTTP.

These matchers give you a good interface for asserting on http4k objects in tests. You can (and will) reuse them time and again.

But can’t we just rewrite that test - in fact all tests - as just some version of JUnit’s `assertTrue`?

Yes, you can. But this leads to “write-only tests” - a flavour of write-only code. The tests do at least a part of their job - they will prevent regression in your system. But when the system  _does_ regress (which is exactly when your tests will start paying off), you will be left with an error message that’s some variety of

```
expected false to equal true
```

Which is no use to anyone. Yes, you’ll have the line number where the assertion failed. And you can go there and start to pick apart exactly what was `false`. But this is in no way as good as seeing something like:

```
expected a response with a code between 200 and 299, but got 404 (Not Found)
```

This gives you a much better idea about what’s going on - the test is not just telling you that your system has regressed, it’s also telling you where to start looking to fix it.

And, yes, we could just write a nicer error message for our `assertTrue` style of testing, but as soon as you start testing the with the same (or similar) assertion again and again, you will end up with repeated code, which you’ll extract into functions or objects, and you’ll be well on your way to writing your own library of assertions.

Hamkrest custom matchers provide a good way to build your library of assertions, taking advantage of the library’s other features - the best being composition.

### Simplest Matcher

Let us assume a simple domain object:

```
data class User(
  val givenName: String,
  val familyName: String,
  val emailAddress: Email,
)
```

All Hamkrest matchers implement the interface `Matcher<T>`, where `T` is the test subject.


So the simplest way to write a matcher would be to write the following in IntelliJ:[^2]

```
object hasGeraldAsTheirFirstName: Matcher<User> {
	
}
```

And then hammer the magic ‘implement interface’ button, which will fill out the required field and method that a minimal `Matcher` needs:

```
object hasGeraldAsTheirFirstName: Matcher<User> {
    override val description: String
        get() = TODO("Not yet implemented")

    override fun invoke(actual: User): MatchResult {
        TODO("Not yet implemented")
    }
}
```

Only two things:

`description: String` is the description that appears in the test output.

`invoke(actual: User): MatchResult`  is the method that is called when the matcher is run. If you’re familiar with Kotlin you’ll recognise it as letting the object be used as a function.

The first one is easily implemented. We just need to write a string that reads well when appended to the words `Expected a value that`.

```
object hasGeraldAsTheirFirstName: Matcher<User> {
    override val description: String =
	    "has the first name of 'Gerald'"

    override fun invoke(actual: User): MatchResult {
        TODO("Not yet implemented")
    }
}
```

`invoke` is where the magic happens. Here we need to return a `MatchResult`. There are two sorts of `MatchResult`: `MatchResult.Match` and `MatchResult.Mismatch(description: String)`. Which one you return depends on whether you want the matcher to match - the test to pass - or not.

```
object hasGeraldAsTheirFirstName: Matcher<User> {
    override val description: String =
	    "has the first name of 'Gerald'"

    override fun invoke(actual: User): MatchResult =
	    if (actual.givenName == "Gerald") {
		    MatchResult.Match
	    } else {
	        MatchResult.Mismatch("the given name was '${actual.givenName}'")
        }
}
```

And that’s pretty much it!

```
@Test
fun `a guy called Gerald`() {
    val user = User(
        givenName = "Robert",
        familyName = "Jones",
        emailAddress = EmailAddress("gerald@gmail.com"),
    )
    assertThat(user, hasGeraldAsTheirFirstName)
}
```

```
expected: a value that has the first name of 'Gerald'
but the given name was 'Robert'
```

It’s at this point, with a failing test, that I like to look at the message I get about the failure and fix it. It’s not nice that the `first name` in the first line doesn’t agree with the `given name` in the second line, or with the `givenName` field in the `User` type. So I should update it.

```
expected: a value that has the given name of 'Gerald'
but the given name was 'Robert'
```

Pretty good. Let’s try some more things:

### Paramaterized matcher

If we wanted to assert on different given names we could write something like:

```
fun hasGivenName(givenName: String): Matcher<User> = 
	object : Matcher<User> {
        override val description: String =
            "has the given name of '$givenName'"

        override fun invoke(actual: User): MatchResult =
            if (actual.givenName == givenName) {
                MatchResult.Match
            } else {
                MatchResult.Mismatch("the given name was '${actual.givenName}'")
            }
    }
```

Nothing too surprising here I hope

```
@Test
fun `another guy called Gerald`() {
    val user = User(
        givenName = "Robert",
        familyName = "Jones",
        emailAddress = EmailAddress("gerald@gmail.com"),
    )
    assertThat(user, hasGivenName("Gerald"))
}
```

```
expected: a value that has the given name of 'Gerald'
but the given name was 'Robert'
```

### Higher Order Matchers

Things only really get exciting when you start writing your own higher order matchers like the ones we saw above - matchers that take other matchers.

What if we wanted to write something like:

```
@Test
fun `a guy who starts with Gerald`() {
    val user = User(
        givenName = "Robert",
        familyName = "Jones",
        emailAddress = EmailAddress("gerald@gmail.com"),
    )
    assertThat(user, hasGivenName(startsWith("Gerald")))
}
```

Here we want to use the built-in matcher of `startsWith` inside our own `hasGivenName` matcher. This is not as difficult as it sounds:

```
fun <S : CaseSensitivity> hasGivenName(matcher: StringMatcher<S>): Matcher<User> =
    object : Matcher<User> {
        override val description: String =
            "has a given name "
        override fun invoke(actual: User): MatchResult = matcher(actual.givenName)
    }
```

This is about as complicated as it’ll get with the built in matchers, as it’s a `StringMatcher` we’re taking as an argument (not unreasonably as it’s a string we’re matching against).

And that’s it! We now have the tools we need to start growing our test assertions upwards, towards our domain types, and reusing them again and again.

[^1]: and anything else that is `Comparable`
[^2]: I am assuming you’re writing Kotlin using IntelliJ IDEA by JetBrains. If not I’d recommend it.

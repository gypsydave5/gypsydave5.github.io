---
layout: post
title: "RSpec Magic Part 2: Verifying Doubles"
date: 2014-12-18 11:22:05
tags:
    - RSpec
    - Ruby
published: false
---

Doubles in RSpec are great - and easy to use. Check this out:

```ruby
my_double = double
```

You can give them name to identify them when they fail in some horrible way:

```ruby
my_double = double "Bicycle"
```

And you can add some messages and return values in a hash afterwards (I'll add
the brackets for clarity):

```ruby
my_double = double("Bicycle", {broken?: false, wheels: 2})
```

One of the problems with doubles in a dynamic language like Ruby is that you've
got no guarantee that the class you're mocking actually implements the method
you've just stubbed. I was taught that the best way to keep an eye on this was
to keep notes on what you were methods you need to implement when you make the
class 'for real'.

There is another way though - *verifying doubles* let you declare the mocks just
as above, but with the added bonus that, if the object's class has been
created in the test suite you're running, it will throw an error if that class
doesn't respond to any of the messages you've mocked. It looks like this:

```ruby
my_double = instance_double "Bicycle", broken?: false, wheels: 2
```

Now if there's no `Bicycle` class about the double acts as previously seen. But
if the `Bicycle` class has been loaded into the test runner, and doesn't
implement either `broken?` or `wheels`, then you'll get an exciting new error
message that looks something like this:

```shell
Failure/Error: instance_double "Bicycle", broken?: false, wheels: 2
    Player does not implement: broken?
```

This behaviour could be incredibly useful (a great kick start to defining a new
class) or a bit of an annoyance (do I really want RSpec moaning at me about all
the methods I've not implemented in a class I've just started work on?).

---
layout: post
title: "RSpec Magic Part 1: Lets"
date: 2014-12-18 11:22:05
tags:
    - RSpec
    - Ruby
published: false
---

When I first started to use RSpec one of the tricks I was shown was how to
extract the set up for each test into a 'let'. It looks something like this:

```ruby
let(:variable_name) { statement }
```

So we can transform a variable declaration in a test block that looks like this:

```ruby
bicycle = Bicycle.new
```

into something more generic that lives in the `describe` block:

```ruby
let(:bicycle) { Bicycle.new }
```

And that's exactly how I used it from there on. You can even do the neat trick
of declaring doubles in a `let`, along with method stubs:

```ruby
let(:broken_bicycle) { double :bicycle, broken?: :true }
```

But let's try and see what's going on here. We have a method `let`, which takes
a *symbol* as an argument, and then takes a block which it assigns to that
symbol, converted to a variable. Another way of writing this, just to make it
explicit:

```ruby
let(:bicycle) do
    Bicycle.new
end
```



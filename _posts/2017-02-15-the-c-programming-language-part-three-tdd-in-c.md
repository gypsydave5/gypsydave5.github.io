---
layout: post
title: "Learning the C Programming Language<br><h2>Part Three: Modules and TDD in C</h2>"
date: 2016-12-03 13:42:01
tags:
    - C
    - Languages
    - Learning
    - TDD
published: false
---

_This post follows on from my [second post about the C programming
language][postTwo], and is the third in a series of posts about learning C_

When I was thinking about writing tests in C, it led me to almost entirely
reevaluate the way I think about tests. If you just want to see how to test in
C (or how I do it anyway), skip to the end. Otherwise...

## There is no magic
When I learned to practice test-driven development (TDD), I learned in Ruby
using RSpec. It was wonderful! RSpec has a delightful syntax, reading like
English. Like this:

```ruby
describe "add" do
    it "knows that five plus two makes seven" do
        expect(add 2, 5).to equal 7
    end
end
```

It's worth bearing in mind that it took a long time to recognize that this was
a series of nested function calls, each with its own code block. Definitely
the start of this was when I started writing tests in JavaScript using the Mocha
framework:

```javascript
describe('add', function () {
    it('knows that five plus two makes seven', function() {
        expect(add(2, 5)).to.equal(7);
    });
});
```

The anonymous `function`s made it much more obvious to me: this is just
JavaScript; there is no magic.

## Back to basics

When I saw a pair of experienced developers hacking on Python for the first
time, I asked them what sort of testing framework they were using - I was
curious! "We're not using a framework," they said, "we're just using `assert`."

This reminded me of my nightmare first experience with Java, where I abused the
JUnit version of `assert` all over the place. But I hadn't realized that it came
'for free' in some languages. In fact, in most languages.

## What is a test?

A test is a way of saying whether something works or not. We could do this in
a repl, we could do it by running a program and using it - manual testing. But
more commonly we write another program to use the first program. This is what
a test framework is - a program that tests your program.

Given this, we need a way to communicate a description of our program to the
test program - this is what we can see in the Ruby and JavaScript examples
above. We're making a statement about our program ('two plus five
equals seven') in the test framework's domain language, and saying that this
should be true. At root, all tests come down to this: is something true or not?

## Enter `assert`

The original intention of `assert` in C was as an assertion that could be
included inside the program itself. You would be able to compile
your program either with the assertions turned on, or turned off by disabling
debugging.

This way of using `assert` doesn't really work for TDD - you can't run the
assertion without having the code in the first place. In addition, you don't get
what for me is one of the chief advantages of TDD, namely enforced separation of
concerns.

### Wait, separation of concerns?

In order to test some aspect of your software on its own, it needs to be
separable from the rest of the code; the testing will drive this. As you build
each new part, you test it separately from the rest.

So how to we break up a C program? The first step should be familiar to most
developers: wrap everything in a function.

### Functions in C

We've already seen a function in C - the `main` function. Declaring our own is
a doddle; let's do some addition:

```c
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int main() {
    int answer = add(1, 1);
    printf("one plus one is: %d", answer);
}
```

This stuff shouldn't be too surprising. The only things worth mentioning are
that there is no magic function declaration keyword like `function` or `def`. In
C it's the presence of the parentheses after the name that make it into
a function. We do need to declare the return type - in both instances it's an
`int` like we saw in [the first post][postOne]. This is the first time we've
seen arguments in a function though - and it's probably not surprising that
they've typed as well. In C the type goes before the name.[^1] So `add` takes two
`int`s and returns an int. Hooray.

Oh, and like JavaScript we have to remember to `return` the result.

[^1]: A fact regretted by Rob Pike and [rectified in Go][goDeclarationSyntax]

[postOne]: {% post_url 2016-08-09-the-c-programming-language-part-one-hello-world.md %}
[postTwo]: {% post_url 2016-12-03-the-c-programming-language-part-two-types %}
[goDeclarationSyntax]: https://blog.golang.org/gos-declaration-syntax

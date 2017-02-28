---
layout: post
title: "Learning the C Programming Language<br><h2>Part Three: TDD in C</h2>"
date: 2016-12-03 13:42:01
tags:
    - C
    - Languages
    - Learning
published: false
---

_This post follows on from my [second post about the C programming
language][postTwo], and is the third in a series of posts about learning C_

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
describe('add', function() {
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

The original intention of `assert` in C was as an assertion about your program
that could be included inside the program itself. You would be able to compile
your program either with the assertions


[postOne]: {% post_url 2016-12-03-the-c-programming-language-part-two-types %}

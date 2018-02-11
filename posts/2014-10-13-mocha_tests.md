---
layout: post
title: "Mocha tests with MongoDB and Mongoose"
date: 2014-10-13 21:23:50
tags: 
    - Makers Academy
    - Node
    - TDD
published: true
---

I've been continuing my assault on Node.js - I refuse to let it lie. I decided
two weeks ago to try and get a version of the Makers Academy chitter project (a
twitter clone) up and running using Node, Express and - because you may as well
go straight in at the deep end - MongoDB. Let's call it 'Chitter.js'.

The biggest pain I've had is getting the tests to run. This may not sound like
a big deal to someone on the outside, but without tests I feel a little lost --
I mean, how do you know if what you're doing is working? Or your refactoring
hasn't changed anything?

Anyway, enough of the TDD rant - and maybe let's just approach this as an
intellectual exercise. Mocha is the test framework we're using -- along with
the Chai library of assertion (so I can write `expect`) a lot.

Now the first thing to bear in mind is just how asynchronous _everything_ is
when working in JavaScript. You may _think_ you understand, but you proaably
don't. My entire cohort at Makers is replete with tales about testing in Mocha
("It passed one time -- but then it didn't" ... "I ran it, it should've failed.
But it passed. Twice.").

Happily Mocha gives us `done`. You can pass any test block (OK, not block,
anonymous function. But I'm Ruby till I die) an argument of `done`, which is
a function you can call when the test is... well, when the test is done. It
basically means that you can make thinga happen when you want them to happen,
and not in faster-than-a-speeding-bullet JS timeframes.

So, here's a test straight out of my actual project. The key thing to note is
the fact that the expectations are sitting in the callback for the `save`
function - you'll only want to test the database once the save has saved (i.e.
once its calledback).

(The following is all in CoffeeScript - which I'm agnostic about. It definitely
has the advantage of brevity, which is a quality all of its own.)

```coffee
it 'saves users', (done) ->
    bob = new user {username: "bob", password: "pisswird"}
    bob.save (error, saved_bob) ->
        expect(saved_bob.username).to.equal "bob"
        expect(saved_bob.password).to.equal "pisswird"
        done()
```

You would expect this to run, test the expectations, and then let you know it's
all finished with the `done()` call at the end of the callback. And it does do
exactly that -- but only so long as the expectations pass. If they don't the
whole thing just times out - which is not what we're after.

I tried a number of solutions to this problem (in fact the above _is_ one of
those solutions - the first attempts were even more worthless), including a few
experiments with the [Chai as
Promised](http://chaijs.com/plugins/chai-as-promised) library which includes
such great statements as `to.eventually.deep.equal` But the problem wasn't
resolved until I hit upon the following pattern:

```coffee
  it 'saves users', (done) ->
    user = new User {username: "bob", password: "pisswird"}
    user.save (error, saved_user) ->
      try
        expect( saved_user.username ).to.eql "bob"
        done()
      catch error
        done(error)
```

What wizardry is this? Let me try to explain...

1. The reason everything timed out on the expectation failing was that the
   expectation statement is no longer in the scope of the `it()`.
2. Expectations pass when they pass -- but when they fail they raise an
   exception which is caught by the `it()` function the whole lot is wrapped in.
3. So when the statement goes out of scope, it means that the error never
   'bubbles up' to the `it`, the `done()` never gets called, and the whole thing
   just times out.
4. So we need a way to send the error for the failed expectation up to the `it()`.
5. This is where the `try/catch` comes in - if the expectation fails it raises an
   error that then gets passed to the `done` function in the catch - which the
   `done` then dutifully carries back up to the `it` with the essential error
   information about what exactly went wrong.

And so now we can write tests. Hurrah! But, more importantly, we've gained an
insight into how testing frameworks work. When I first encountered testing in
RSpec I went through the various patterns of test as ritual -- 'this is how you
do it' -- but the more I work with tests the more I'm respecting the hard work
that's gone in to making them look like magick.

So I'm really greateful for Mocha being a bit of a pain to test with over the
last few weeks, as it's made me have to think a bit harder about testing in
general and the dark arts of JS.

That said, it's not done much for the development of chitter.js...

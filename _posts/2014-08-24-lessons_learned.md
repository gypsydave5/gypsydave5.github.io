---
layout: post
title: "Lessons Learned"
date: 2014-08-24 10:20:19
tags: [Makers Academy, coding, Ruby. bitwise]
categories: Makers
published: true
---

Things I've learned so far from my teachers:

###[Stephen] - Succinct Semantics

I felt a little smug about my code when Steve sat next to me to see how I was
doing. I was seeing if there were any broken bikes in an array, something like

```ruby
bikes.select {|bike| bike.broken?}.count > 1
```

He took a quick look and pointed out that this was a little on the long side.
Does Ruby have an `any?` method for `Array`s? Sure enough, there in `Enumerable`

```ruby
bikes.any? {|bike| bike.broken?}
```

Better. I would have been happy. But Steve then says, try passing a the symbol
for `broken?` as a proc - something I'd seen and not used.

```ruby
bikes.any?(&:broken?)
```

See how that's better? It says exactly what it does? Yes, I did. And I'd learned
that you don't have to sacrifice succinctness to semantics and vice versa. Ruby
has enough well-named methods and techniques to create a short statement that
someone who didn't know Ruby would still understand. Lesson learned.


###[Mihai] - Delete Your Code

I asked Mihai for some help changing my tests for the Boris Bikes project. I was
trying to change the Rspec tests I'd written from [Chicago to London
style][ChiLon] having just been shown how to do doubles.

Start again, Mihai said. Don't be precious or treasure what you've written
- just get rid of it and start again. You'll learn more that way.

Since then I've taken immense pleasure in wiping entire projects out. And
learned more by doing that. Lesson learned.

###[Enrique] - Cooking without ever having have Eaten

Late in the day I asked Enrique about program design. I was worried, really
worried, that I didn't know the right way to proceed with writing a program.
He'd just introduced the idea of design patterns that day, so I asked him to
recommend a book, or a checklist, or a mantra - the best way to learn some
patterns.

Even as I spoke, Enrique started moving him hands, miming typing in front of me.
Remember what I said earlier, he said, about coding being entirely artificial.
It's not like cooking where you know what food is and what it tastes like. It's
like cooking when you've never eaten food, have no idea what good or bad food
tastes like. The only way you'll learn is by writing code, a lot of code. Then
your instincts, your taste and intuition, will improve.

It was only later that I connected this advice up with [Bergson's ideas about
creativity, specifically the swimming example][Bergson_swim]. You wouldn't think
a person could swim if you only ever saw them walk, the argument goes. For
swimming to be intellectually comprehendable, you've got to throw yourself in
the water first. You can't theorize about things you haven't done - intuition
must take the lead, intelligence is a practical faculty (not a speculative one).

Mind blown, I staggered home, ignored *The Rspec Book* and wrote more code.
Lesson learned.

[MA]: http://www.makersacademy.com/
[Enrique]: https://twitter.com/ecomba
[Stephen]: https://twitter.com/Stephen_lloyd
[Mihai]: https://twitter.com/liviu_23
[Alex]: https://twitter.com/alexpeattie
[ChiLon]: http://programmers.stackexchange.com/questions/123627/what-are-the-london-and-chicago-schools-of-tdd
[Bergson_swim]: http://en.wikipedia.org/wiki/Henri_Bergson#Creativity

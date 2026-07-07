---
title: In Defence of Architecture
description: In which architecture as an idea in software is defended
published: true
date: 2026-07-02 10:36:45
tags:
  - PortsAndAdaptors
---

_**Dave Does Architecture** - a series:_

1. **In Defence of Architecture** - _you are here_
2. [The Parts of a Ports and Adaptors Application](/posts/2026/7/3/the-parts-of-a-ports-and-adaptors-application)
3. [Wiring Up a Ports and Adaptors Application](/posts/2026/7/3/wiring-up-a-ports-and-adaptors-application)
4. How Do You Test a Ports and Adaptors Application? _(coming soon)_
5. Where Does Authentication Go? _(coming soon)_

---

This is an opinionated approach to building a system. It's aimed at web applications, but there's nothing here that wouldn't apply just as well to anything else that takes input from the world, does something, and gives something back.

It draws heavily on Ports and Adaptors - [Alistair Cockburn's Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/), which is where the pattern, and most of the terminology I use here, comes from - and on Clean Architecture, as laid out in [Getting Your Hands Dirty With Clean Architecture](https://learning.oreilly.com/api/v1/continue/9781805128373/). Where I think the book or Cockburn could be clearer, I depart from them. Familiarity with all of the above will help, but I'll define my terms as I go.

Here's the whole of what I want to get across. It grew too big for one post, and so it's turning into a series of posts. Think of it all as _Dave Does Architecture_:

- the **parts** of a ports and adaptors architecture, and the terminology that goes with them - the domain, the ports, the adaptors, the use cases, and how they depend on one another. That's this post.
- how you **wire it all up** when the program starts - in what order, from the edges in, and where the construction code belongs. That's [Wiring Up a Ports and Adaptors Application](/posts/2026/7/3/wiring-up-a-ports-and-adaptors-application).
- the **testing strategy** that falls out of the whole thing - which, it turns out, is most of the reason to bother. That's for later.
- And probably something on package/dependency structure, using fitness functions like Konsist (both of these to try and steer you away from screwing up the architecture), as well as a few worked examples on the bits that I have always messed up and how I think you can do them _right_ (I'm looking at you, authentication).

But before any of that, let me try to explain why I'm doing it this way, with a crappy metaphor...

### Building A City Every Day 

An architecture is like a map of a city. It tells you where things are and how they connect - the domain in the middle, the ports at the edges, the roads between them. It's genuinely useful. But a map doesn't tell you how to _build_ the city. Hand someone a map and a pile of bricks and you'll get a mess.

What I actually want is the instructions. Not a blueprint but something like the instructions in a Lego kit: _this_ bit first, then _this_ bit, then _this_ - a fixed order, one bag at a time, with the big picture on the box to check yourself against.

The order is the point, because the order is one of the things that can help stop you making a mess. If there is exactly _one_ place where objects of type A get built, then you always know where to add the next one - and, just as importantly, you know you've done something wrong the moment you find yourself constructing an A somewhere else. An adaptor conjured up ad hoc inside an HTTP handler is the software equivalent of throwing up a warehouse in the middle of a residential street. If all the commercial buildings go up together, in the commercial-buildings step, the zoning violations get a lot harder to commit by accident.

The metaphor breaks down in one obvious place: we don't knock cities down and rebuild them from nothing every morning. But we do exactly that with software - every time the process starts, the whole city goes up again from an empty field. Software is weird like that. If anything it makes having the building instructions even more important, so that every time you add a new brick (metaphor getting creaky) you know you're adding it at the right _time_ and in the right _place_.

And, in my experience, it's in the "building a city every day" part that things tend to go wrong - in the wiring up parts. People spend a long time talking about the architecture, but not nearly enough time talking about a good way to bring it all together. So really the beating heart of this is the wiring up post, everything else is just to get us there.

---

Now for some reason, at this point, I had the horrible thought that all my colleagues who ever said that architecture was pointless and we should JFDI, put the function there, and get on with our lives - I had the horrible thought that maybe they were right. And that maybe you're one of them. So I ended up writing a defence of architecture.

## Architecture

### Why even have an architecture?

This might sound mad, but it's worth at least asking ourselves why we want to choose an architecture. What even is architecture in software, and why do we care about it? I think particularly about when I want to talk to THE BUSINESS. Why do they care?

#### Architecture is a silly name

First, I _hate_ the word architecture. The first thing I think about is architects, who in parodic form (well, mostly parodic) go about drawing lines and boxes on their ivory whiteboards, never build anything themselves, aren't on the hook for delivering anything, and float around with a peculiar sense of superiority because they never have to get their hands dirty with the base irrelevancies of working software.

I usually prefer the word "design" as it tends to scare people off less. Design is what we do all the time - write a class, a method signature, some functions that all work together. We're always designing. Architecture feels so... eugh... distant and grown-up.

Well, let me tell you: architecture is just design, even the really big architectures. It's all just design. The only difference is usually scale. We design classes, but we feel like we're architecting when we design distributed systems.

#### Architecture is just Object-Oriented Programming on stilts

The next thing I want to tell you is that if you can design the interactions between a few stateful objects in object-oriented programming, then congratulations, you have the skills to be an architect. The same problems that come up at the "object" level (usually to do with time and state - it's always time and state and concurrency) exist all the way up the stack. It's one of the benefits of the "object metaphor": an object can be seen as a tiny little computer. So if you can work with lots of tiny little computers, you can also work with lots of big wobbly computers.

The reason we're talking about a ports and adaptors architecture here is because "ports and adaptors design" sounds a bit silly. So architecture it is, but feel free to say "design" in your head.

But we've not answered my question: why architect at all? Two tempting answers, both too thin.

#### It tells you where things are?

In its simplest form, architecture is just a folder structure, right? We put _this_ sort of function over _here_ and _that_ sort of function over _there_. So now I know where all the functions that deal with maths are.

"What is the best folder structure for my node / Go / python project?" the cry goes out. The _intention_ is good - keeping things organized. But being "organized" isn't an architecture. Putting all my yellow bricks together, and then all my red bricks together, is not a building.

Well, that's nice. But what sort of functions are we talking about?

#### It makes things work?

The architecture should let the system do the things that it's meant to do. So if it's a web app, then some of those functions we're talking about above are going to have to be what sometimes gets called a "handler" - HTTP request in, HTTP response out.

Or not! You could just have one huge function, right? Does all the routing, does all the handling, does all the logic. A big old `while` loop. So why bother architecting again?

#### Noooo, it makes things _easy to change_

This is the real answer for me. Making a system that works is easy. Making it easy to change in the ways you need it to change, that's the trick. Making it _stay_ easy to change even when you're changing it - that's the gold standard.

So what do I actually need in order to make a change to a system without pain?

- I need to know how the system works right now;
- I need to decide where the change needs to be made;
- and how to make that change;
- and that the size of the change should be small
- then I need to do it...
- ...see that it works...
- ...and do all that without making it harder to make any _other_ change in the future.

A good architecture gives you this. Or it at least helps.

##### Know how it works right now

The architecture should tell you how the system works now. It should tell a story. It's hard to see that story if there are three different ways of parsing a request and seven ways of serializing JSON - and it's even worse when sometimes you serialize the JSON in a request handler and other times you do it before.

We make the story easier to read by giving it a narrative flow - first _this_, then _this_ - and naming each of the stages. We make it easier to see that two stories are the _same_ by giving the same names to the parts that do the same job. Decomposed and named consistently, the code becomes something you can read.

So when we come to make a change, we can see how the existing small parts are used to tell a story - and how we'd use them to tell a new one.

##### Know where the change goes

Once the parts fall into distinct categories, working out where a change goes gets a bit easier. This sounds like it shouldn't even be a problem, but I cannot even begin to tell you the amount of time I've spent scratching my chin looking at my IDE and trying to work out _where_ this new magic box will go.

But with a decent architecture - whew! Change to the UI? Fiddle with that view-model and the HTML. New thing the application needs to do? Ooooh, I'll need a use case and some adaptors. Different database? Time to swap out my out-port. (Don't worry about those words yet - they get named and defined properly in [the next post](/posts/2026/7/3/the-parts-of-a-ports-and-adaptors-application). The point is only that there _are_ names, and each name names a home).

And the flip side is, if anything, _more_ useful: you know where a change does _not_ belong. If you're building a database connection in your router, you are doing it wrong.

##### Know how to make it

Because every part is small, and plays one part in our story, and often has a few siblings that already play the same _kind_ of part, you rarely have to invent anything. You make the new one by following the shape of the ones next to it. A codebase built this way is really a pile of worked examples: you want a new adaptor, so you open the three adaptors that already exist and write a fourth that looks like them.

##### And it's a small change

This is the most important bit. This is the bit where we can talk about coupling and cohesion, we can talk about Larry Constantine in '68 and Kent Beck and other amazing things. If good architecture makes things easy to change, then the beating heart of that isn't all the stuff above - that's the easy stuff that I'm going to spend most of my time talking about because I'm not Larry Constantine or Kent Beck. 

The beating heart of it is this: 

- that you make the things that _should_ change at the same time as each other _easy_ to change at the same time as each other
- and don't force the things that _shouldn't_ change at the same time to change at the same time as each other

I've made a mess of that, and you'll find better definitions [on the internet thank you Ward](https://wiki.c2.com/?CouplingAndCohesion), but the first one is "cohesion" and the second one is "coupling". You want more of the first thing, and less of the second thing. You should go and read better people than me on this subject as it's the very heart of good design.

And, blow me down, if that's not what we're getting when we buy in to the ports and adaptors - we are decoupling our domainy code in the middle from the transport layers (the HTTP, the DB), and also decoupling the implementations of the things outside in the world (the adaptors) from what they mean and do for us (the ports).

I'll say it again: _minimizing coupling and maximizing cohesion should be the point of architecture_. This is what _really_ makes the changes technically easy. 

##### See that it works

By having a small, simple object with limited responsibilities and behaviour, it lets you lift it out of its context and hold it on its own - which is exactly what you need to check that it works. You can run the piece you changed without standing up the entire universe around it: drive it directly, put something predictable on the other side, and look at what comes back.

But quite often we _do_ want to make sure that our objects work in the context of each other. Because our objects are joined together in a consistent way to perform a task, we can also be just as consistent about the ways we test them from end to end. I'm reserving testing strategies for a later post (or two or three), but this is what I'm talking about here.

##### ...and don't make the next change harder

All of the above is making it easier to make a change to your application. But here's the final twist: not only do you want it easy to change _now_, you want to _keep_ it just as easy to change _after_ you've changed it. 

This is where we could go and have a whole discussion about technical debt - which is really just the stuff you added that stops you making the changes you need to make easily, usually because you didn't know what changes were coming.

That trick - seeing into the future to work out what changes are coming down the line - is why good developers spend so long thinking about the _domain_: the situation the application lives in, the problem it's there to solve. Understand the domain and you understand the changes that are realistically coming, so that you know - to pick the classic - that using a floating-point number for an account balance is _a bad idea_.

But I'm _not_ talking about the business domain here. That's _your_ problem. What I'm talking about is the ports and adaptors architecture. And what ports and adaptors gives you is a design that separates the logic for working with your domain from the concerns of talking to, and changing things in, the rest of the world. And it's an architecture that's designed to keep having things added to - the architecture, as architects love to say, _scales_.

And if you follow it closely, that architecture will be the same both before and after the change that you've made. And so the next change will be just as easy to make, for all the same reasons above.

##### THE BUSINESS returns

But why do we care about easy changes? THE BUSINESS. They want you to work quickly, and efficiently, and consistently deliver value. They not only want the change you make now to be quick, but they want the change you make tomorrow, next week, next month, next year, to be just as quick. Which is _why_ THE BUSINESS really cares about architecture, even if they don't know it.

---

## So what was all that for?

Goodness, that was long. I'm sorry.

What you get from taking time and care over your design, your tem that's _easy to change_. Why is it easy to change? Because of the properties I outlined above.

What are the nature of these properties? There are really two sorts. The first and most important property of all architecture is  that it should help "making the change small" - that is, the architecture should promote cohesion and reduce coupling, both now and in the future. We reach for architectural patterns like ports and adaptors because their design has this property, and we can see how the same design is maintained through changes, preserving the property as you grow your system.

All the other properties are expressions of having what is a called a ["screaming architecture"][screaming], one that makes it hard to ignore what the architecture of the system is. If your architecture _screams_ at you to the point where it's hard to forget what the architecture is, then changes are easier because 

- you can see what to do and where to do it quickly and don't waste time scratching your chin working out where to put the code
-  reduce the chances of you making the change in the wrong place, which will be harder, and take more time
- finally, you will find it easier to maintain the architecture, and so continue to minimize coupling and maximize cohesion

Now _how_ those properties emerge, that is a question for the architecture in specific, not in general. To see _how_

- [the parts](/posts/2026/7/3/the-parts-of-a-ports-and-adaptors-application) in a ports and adaptors architecture can be made to _scream_ and how they support cohesion and reduce coupling,
- my opinions about [wiring them together](/posts/2026/7/3/wiring-up-a-ports-and-adaptors-application) in a way that _screams_

How all of them work together into making the whole system easier to change, well that's coming up next.

[screaming]: https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html

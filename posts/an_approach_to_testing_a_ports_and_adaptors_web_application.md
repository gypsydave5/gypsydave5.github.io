---
title: The Architecture Is the Easy Part
description: Anyone can draw the hexagon. The value is in how you wire a ports-and-adaptors application together - which is what makes it easy to change, and easy to test.
published: true
date: 2026-07-02 10:36:45
tags:
  - PortsAndAdaptors
---

This is an opinionated approach to building a system. It's aimed at web applications, but there's nothing here that wouldn't apply just as well to anything else that takes input from the world, does something, and gives something back.

It draws heavily on Ports and Adaptors - [Alistair Cockburn's Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/), which is where the pattern, and most of the terminology I use here, comes from - and on Clean Architecture, as laid out in [Getting Your Hands Dirty With Clean Architecture](https://learning.oreilly.com/api/v1/continue/9781805128373/). Where I think the book or Cockburn could be clearer, I depart from them. Familiarity with all of the above will help, but I'll define my terms as I go.

Here's the whole of what I want to get across. It grew too big for one post, so it's really a short series - but the ambition is one joined-up thing:

- the **parts** of a ports and adaptors architecture, and the terminology that goes with them - the domain, the ports, the adaptors, the use cases, and how they depend on one another. That's this post.
- how you **wire it all up** when the program starts - in what order, from the edges in, and where the construction code belongs. That's [Wiring Up a Ports and Adaptors Application](/posts/2026/7/3/wiring-up-a-ports-and-adaptors-application).
- the **testing strategy** that falls out of the whole thing - which, it turns out, is most of the reason to bother. That's for later.

But before any of that, let me try to explain why I'm doing it this way, with a metaphor:

An architecture is a map of a city. It tells you where things are and how they connect - the domain in the middle, the ports at the edges, the roads between them. It's genuinely useful. But a map doesn't tell you how to _build_ the city. Hand someone a map and a pile of bricks and you'll get a mess.

What I actually want is the instructions. Not a blueprint but a Lego kit: _this_ bit first, then _this_ bit, then _this_ - a fixed order, one bag at a time, with the picture on the box to check yourself against.

The order is the point, because the order is what stops you making a mess. If there is exactly _one_ place where objects of type A get built, then you always know where to add the next one - and, just as importantly, you know you've done something wrong the moment you find yourself constructing an A somewhere else. An adaptor conjured up ad hoc inside an HTTP handler is the software equivalent of throwing up a warehouse in the middle of a residential street. If all the commercial buildings go up together, in the commercial-buildings step, the zoning violations get a lot harder to commit by accident.

The metaphor breaks down in one obvious place: we don't knock cities down and rebuild them from nothing every morning. But we do exactly that with software - every time the process starts, the whole city goes up again from an empty field. Software is weird like that. If anything it makes having the building instructions even more important.

OK, let's get going. Starting with our city map, the architecture.

## Architecture

### Why even have an architecture?

This might sound mad, but it's worth at least asking ourselves why we want to choose an architecture. What even is architecture in software, and why do we care about it? I think particularly about when I want to talk to THE BUSINESS. Why do they care?

First, I hate the word architecture. The first thing I think about is architects, who in parodic form (mostly) go about drawing lines and boxes in their ivory towers, never build anything, aren't on the hook for delivering anything, floating around with a smug sense of superiority because they never have to get their hands dirty with the irrelevancies of working software.

I usually prefer the word "design" as it tends to scare people off less. Design is what we do all the time - write a class, a method signature, some functions that all work together. We're always designing. Architecture feels so... distant and grown-up.

Well, let me tell you: architecture is just design, even the really big architectures. It's just design. The only difference is usually scale. We design classes, but we feel like we're architecting distributed systems.

The next thing I want to tell you is that if you can design the interactions between a few stateful objects in object-oriented programming, then congratulations, you have the skills to be an architect. The same problems that come up at the "object" level (usually to do with time and state - it's always time and state and concurrency) exist all the way up the stack. It's one of the benefits of the "object metaphor": an object can be seen as a tiny little computer. So if you can work with lots of tiny little computers, you can also work with lots of big wobbly computers.

The reason we're talking about a ports and adaptors architecture here is because "ports and adaptors design" sounds a bit silly. So architecture it is, but feel free to say "design" in your head.

But we've not answered my question: why architect at all? Two tempting answers, both too thin.

#### It tells you where things are?

In its simplest form, architecture is just a folder structure. We put _this_ sort of function over _here_ and _that_ sort of function over _there_. So now I know where all the functions that deal with maths are.

Well, that's nice. But what sort of functions are we talking about?

#### It makes things work?

The architecture should let the system do the things that it's meant to do. So if it's a web app, then some of those functions we're talking about above are going to have to be what sometimes gets called a "handler" - HTTP request in, HTTP response out.

Or not! You could just have one huge function, right? Does all the routing, does all the handling, does all the logic. A big old `while` loop. So why bother architecting again?

#### It makes things _easy to change_

This is the real answer, and it's worth the whole post. What do I actually need in order to make a change to a system without pain?

- I need to know how the system works right now;
- I need to decide where the change needs to be made;
- and how to make that change;
- then I need to do it...
- ...see that it works...
- ...and do all that without making it harder to make any _other_ change in the future.

A good architecture hands you each one. Let's take them in turn.

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

##### See that it works

By having a small, simple object with limited responsibilities and behaviour, it lets you lift it out of its context and hold it on its own - which is exactly what you need to check that it works. You can run the piece you changed without standing up the entire universe around it: drive it directly, put something predictable on the other side, and look at what comes back.

But quite often we _do_ want to make sure that our objects work in the context of each other. Because our objects are joined together in a consistent way to perform a task, we can also be just as consistent about the ways we test them from end to end. I'm reserving testing strategies for a later post (or two or three), but this is what I'm talking about here.

##### ...and don't make the next change harder

All of the above is making it easier to make a change to your application. But here's the final twist: not only do you want it easy to change _now_, you want to _keep_ it just as easy to change _after_ you've changed it. 

This is where we could go and have a whole discussion about technical debt - which is really just the stuff you added that stops you making the changes you need to make easily, usually because you didn't know what changes were coming.

That trick - seeing into the future to work out what changes are coming down the line - is why good developers spend so long thinking about the _domain_: the situation the application lives in, the problem it's there to solve. Understand the domain and you understand the changes that are realistically coming, so that you know - to pick the classic - that using a floating-point number for an account balance is _a bad idea_.

But I'm _not_ talking about the business domain here. That's _your_ problem. What I'm talking about is the ports and adaptors architecture. And what ports and adaptors gives you is a design that separates the logic for working with your domain from the concerns of talking to, and changing things in, the rest of the world. And it's an architecture that's designed to keep having things added to - the architecture, as architects love to say, _scales_.

And if you follow it closely, that architecture will be the same both before and after the change that you've made. And so the next change will be just as easy to make.

Why do we care about easy changes? THE BUSINESS. They want you to work quickly, and efficiently, and consistently deliver value. They not only want the change you make now to be quick, but they want the change you make tomorrow, next week, next month, next year, to be just as quick. Which is _why_ THE BUSINESS really cares about architecture, even if they don't know it.

---

## So what was all that for?

Goodness, that was long. I'm sorry. But I've spent all those words on _why_ without showing you a single box, so let me say plainly what the boxes buy - because it isn't the diagram. Anyone can draw the hexagon.

What you get is the thing this whole post was about: a system that's _easy to change_. And the reason lives in the two edges. They are _hinges_ - [Kent Beck's word](https://newsletter.kentbeck.com/p/hinge) - the places the application is deliberately built to bend. The out-ports are the hinge between your logic and the world it depends on: swap a database, change a provider, and nothing above the hinge has to move. The in-ports are the hinge between your logic and the world that drives it: add HTTP, add a CLI, and nothing below the hinge has to move. A change that would ripple through a tangled codebase stops at a hinge instead.

And here's the loop that makes it all worth the trouble: the very hinges that make the application easy to _change_ are what make it easy to _test_. To test a thing you have to be able to take it apart and hold a piece still - which is exactly what a hinge is for. Easy-to-change and easy-to-test turn out to be one property seen from two sides; buy one and you've bought the other.

That's the case for the whole approach. What's left is the doing of it: [the parts, named and defined](/posts/2026/7/3/the-parts-of-a-ports-and-adaptors-application); [how you wire them together](/posts/2026/7/3/wiring-up-a-ports-and-adaptors-application); and how the testing falls out.


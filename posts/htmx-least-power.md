---
title: HTMX and the Rule of Least Power
description: less is more
published: true
date: 2024-04-12 22:52:55
tags:
  - HTML
  - Frontend
  - JavaScript
  - HTMX
---


The [Rule of Least Power](https://www.w3.org/2001/tag/doc/leastPower.html)

> suggests choosing the least powerful [computer] language suitable for a given purpose

As a principal it’s applicable for all programming, but it finds particular relevance when working in the frontend of web development. The link above is to the W3C article on the subject, written by Tim Berners-Lee.

He continues:

> Many Web technologies are designed to exploit the Rule of Least Power. HTML is intentionally designed not to be a full programming language, so that many different things can be done with an HTML document: software can present the document in various styles, extract tables of contents, index it, and so on. Similarly, CSS is a declarative styling language that is easily analyzed. The Semantic Web is an attempt, largely, to map large quantities of existing data onto a common language so that the data can be analyzed in ways never dreamed of by its creators… Thus, HTML, CSS and the Semantic Web are examples of Web technologies designed with “least power” in mind. Web resources that use these technologies are more likely to be reused in flexible ways than those expressed in more powerful languages.

If you sign up to this - and I do, to be clear - then you’re going to feel very uncomfortable about the direction frontend frameworks like React and others, where we wind up doing everything in the most powerful part of the frontend stack - the JavaScript.

If we were to graph, in a very realistic and not made up way, the different power levels of the three classic frontend technologies - HTML, CSS and JavaScript - we’d see something like this:

![jspowergraph.png](/images/jspowergraph.png)

JavaScript is super powerful… but we know from the Rule of Least Power that this is _not a good thing_.

And we don’t like React et al because they essentially encourage you to only use the most powerful tool available to you. They sucking the life out of the other technologies and into JavaScript. This is where we get to golden hammers etc.

And so we, the True Believers, avoid the frameworks, and use the least powerful tool for the job. The end.

Well...

Take a look at that graph again:

![jspowergraph.png](/images/jspowergraph.png)

Now, obviously this is not to scale - JavaScript is far more powerful than the other two. Waaaay more. It’s a whole general purpose programming language. We can write servers in it. We can program fridges with it. Waaaaaaay powerful.

And let’s talk about escalation.

## Escalation

Imagine these weren’t web technologies.

`HTML / CSS / JavaScript`

Imagine they were knives, and you wanted to cut up a melon.

`butter knife / cheese knife / lightsabre`

or if they were weapons:

`stick / stone / hydrogen bomb`

or books:

`Goodnight Moon / Spot the Dog / Ulysses`

I hope I’m making my point here and don’t have to think of any more stupid examples. What I’m trying to say is that there’s a real escalation that happens when we move from HTML + CSS to JavaScript. We’re drawing on one of the most powerful forces in the universe to… checks notes… load a bit of HTML onto the page?

Add a spinner?

Send a `DELETE` request?

My point is that there’s nothing in between with the classic web stack. You’re either doing CSS + HTML or you’re using a tool that is insanely more powerful than it needs to be to do the job you want it for. We’re always having to get out the big guns to do relatively trivial things.

## So HTMX, eh?

And here’s the pitch: a tool like [HTMX](https://htmx.org/) is explicitly trying to introduce a less powerful tool than JavaScript to the frontend technology stack.

![midpowered htmx](/images/htmxmidpower.png)

Yes, it is ‘like’ React in that it is something you’re adding to the mix. And, yes, it’s written in JavaScript - that’s to be expected, as most of our simpler technologies are built on top of much more powerful ones.[^1]

But the difference is that it doesn’t try to extend JavaScript to make it the one stop shop for all your webdev needs. Instead it inserts itself between HTML + CSS and JavaScript as a mid-power technology. Instead of being embedded in a high-power language, it’s actually an extension of the low-power language - HTML - extending its capabilities to give it what you need.

You need to do [click to edit](https://htmx.org/examples/click-to-edit/), [lazy loading](https://htmx.org/examples/lazy-load/), [infinite scroll](https://htmx.org/examples/infinite-scroll/), a [live search](https://htmx.org/examples/active-search/), or anything else that you’d normally be reaching for JavaScript to accomplish, you can now add HTMX to the stack, write a few more attributes on your HTML, get what you need done, _and never have to use JavaScript_. Instead you’ve used a less powerful tool (HTMX) to achieve what you wanted.

Yes, there is some overhead - a new dependency, a new thing to learn. Nothing is free in this life. But it’s very distinct to frontend frameworks embedded in JavaScript which pull you in to more JavaScript, all the JavaScript, all the time. HTMX wants you to write _no_ JavaScript _unless you need to_.

## Conclusion

HTMX introduces a tool to the stack, a tool slightly more powerful than HTML, that lets you get most of what you want in modern web development done without having to get out the JavaScript big guns. In so doing it makes it possible for the modern frontend web developer to conform more closely to the Rule of Least Power.

[^1]: In many ways writing a program for someone else - writing a language for someone else - is just a way of reducing the near infinite number of things they can do with a computer, in exchange for making it simpler and easier to do _some_ things with it.
---
title: "Technical Debt"
date: 2026-01-26 12:33:00
published: false
description: "A lightning talk about technical debt"
tags:
  - programming
  - technical debt
  - software engineering
---

## What is Technical Debt?

The term "technical debt" was coined by Ward Cunningham in 1992. He used the financial metaphor to explain to non-technical stakeholders how shipping code quickly could create a "debt" that would need to be "repaid" later through refactoring. Like financial debt, technical debt isn't inherently bad - it can be a strategic decision to ship faster - but the "interest" accumulates over time, making future changes more costly and difficult.

The reason the metaphor works well is that it's something that most business
people have a near instant understanding of. Business people understand debt and
interest as that's most of their lives. The issue I see is that lots of software
developers _don't_ understand the debt metaphor. And so "technical debt" becomes
synonymous with "bad code". Which _really_ isn't the point.


## Understanding the Debt Metaphor

So before we start talking about "technical debt" let's just talk
about _debt_ in general. Let's talk about businesses specifically
though - so a business loan.

When a business borrows money, it's doing it for a good reason. It's
seen an opportunity to make money (all businesses are trying to make
money - that's the goal), but it doesn't have the resources to take
advantage of that opportunity. And in order to get those resources
now, it needs money.

So the rough plan is

1. See opportunity
2. Work out plan to exploit opportunity
3. GET MONEY TO EXECUTE PLAN
4. Execute
5. ????
6. Profit

Wonderful. Your business is now rolling in money.

The only small snag in all this is that the lender is going to charge
you _interest_ on that loan. I'm sorry, this is just how they make
money. What this means is that they will ask for a percentage of that
loan to be paid back on a regular schedule. Not to pay back the loan,
no. The interest is just the "price" of having been given some money.

And so when you get to 6. Profit, you better hope that what you've
built is enough to pay off that interest on the loan. Ideally, it
would pay off the loan as well, but rarely. Plenty of businesses just live
with a certain level of debt at any time, because it's more important
that they're exploiting opportunities to make money rather than paying
down the debt.

Of course, you don't have to pay the interest - you could just borrow
_that_ money as well. So the amount you've borrowed increases. And as
a result, the amount of interest you pay also increases. This could be
thought of as a debt spiral; if you're not paying off the interest
then you're on a path to bankruptcy - essentially where the lender no
longer believes that you can pay off your loan, and so they come over
and start taking all the assets of your business to recoup their
money, and you have nothing. Bad times.

### Software Debt

Let's start with Ward. And let's go back to _1992_, at OOPSLA, where
Ward gives his experience report of working with the WyCash Portfolio
Management System.

The key paragraph is:

> Another, more serious pitfall is the failure to
> consolidate. Although immature code may work fine and be completely
> acceptable to the customer, excess quantities will make a program
> unmasterable, leading to extreme specialization of programmers and
> finally an inflexible product. Shipping first time code is like
> going into debt. A little debt speeds development so long as it is
> paid back promptly with a rewrite. Objects make the cost of this
> transaction tolerable. The danger occurs when the debt is not
> repaid. Every minute spent on not-quite-right code counts as
> interest on that debt. Entire engineering organizations can be
> brought to a stand-still under the debt load of an unconsolidated
> implementation, object- oriented or otherwise.

There's a lot that's worth unpacking here (I'd love to consider
whether the entire industry has created specialization of programmers
because everyone is drowning in technical debt).

But the bit we want is

> Shipping first time code is like going into debt.

Shipping your first take on the problem, for Ward, is like debt - a
debt of understanding. What you built was inevitably "wrong" in some
way - some part of the problem was almost certainly misunderstood. And
that gap between perfect understanding and what got released - that's
the debt.

The notion that this is an "understanding" level issue is made
explicit later where he contrasts the debt metaphor with
waterfall. Waterfall's "working out a program in detail before the
programming begins... amounts [in debt terms] to preserving the
concept of payment up-front and in-full." Whereas incremental software
development - using the debt model - allows the software that still
misses total understanding of the problem to be released. It is
released _both_ to satisfy the customer _and_ for the developers to
gain more understanding of the domain they're working in through
feedback.

The issue comes when this new understanding gained isn't fed back into
the software. Why wouldn't it be? Because the business is happy with
what it's got - "immature code may work fine and be completely
acceptable to the customer". Ward needed a way to explain that, in
order to keep delivering the new software that the client, the
developers needed to do some work - to "pay off the debt" of not
knowing what they were doing at the beginning. And so we have the debt
metaphor.

And then the metaphor escaped into the wild and... well, it changed.

### The Common Understanding

Forward over fifteen years and where are we, how has the debt metaphor
changed? Here's a couple of posts, one by Robert Martin, one by Martin
Fowler. Both well regarded (and for good reason) in the software
development community.

What's interesting about both of these posts is they're _both_ railing
against an opinion that suggests that technical debt is "poor quality
code". Robert Martin is pointing out that technical debt is not a
"deliberate mess", Fowler that it's not e


---

Technical debt - the original technical debt that Ward was talking
about - _is not a deliberate decision of the developers_. It is _not_
a techical decision. It's the effect of deciding to do iterative
development, the cost of that you are paying for not knowing
everything up-front.

And we know now, as good agile developers, that we have to work this
way; we know we never totally understand what we're trying to build,
even if we analyse something to death in a big, up-front, waterfall style.

What Ward is saying is that - even if our system meets the
requirements of the business, it will still not reflect any new
understanding that the developers have gained about the system and the
business through developing and releasing it.

And that's the debt. "If we knew then what we know now, would this be
how we built it?" No? Then that difference is the debt you've incurred
from your initial ignorance. In Ward's original model, all debt is
inadvertant and inevitable. 

So where does that leave all the other debt?

If we take Fowlers model, there's the category of "Reckless" debt,
either deliberately or inadvertantly doing the wrong thing. And all
the things in the reckless half of the grid are - frankly - not useful
things to explain to the business (despite what Fowler says). Because
what they're saying is "we are not professional developers". They
demonstrate ignorance, not of the specific system you're building and
its relationship to the problems it solves.

Ward is expecting a certain level of professionalism from the
developers he's addressing; a certain level of skill and
understanding.

If I decided to rewire a plug, and didn't look up how to wire a plug
before I did it, and then wired it up wrong and burnt down the house,
you wouldn't call that "technical debt". You'd call me a bloody
idiot. And you'd be right. And you'd suggest I read the manual. And
you'd be right again.

If that was software development, and we start calling the big ball of
mud that an inexperienced or lazy developer has made "technical debt",
the term loses meaning. If that's technical debt, and our deliberately
bad architecture we made to rush something out of the door is
technical debt, and the fifty-three outdated npm modules I need to
update is technical debt, and Ward's "partial understanding" is also
technical debt, then it's meaningless. It's just another way of saying
"bad code". 

Dressing these things all as technical debt is disingenous to the
business; if your developers are bad at writing code, then that's not
technical debt, that's just developers being bad at writing code. Call
HR or start some training. 

If the bunch of contractors who built this sytem and then dumped it on
you afterwards made a mess, then that _might_ be technical debt. If
the code is good, and it serve its purpose,  but just dosen't have the
same understanding as you do, then that's some debt. If it's crap code
(written not in the house style, using some nutters vision of what
functional programming _ought_ to look like) - then it's crap
code. Stop hiring contractors, or manage them better.

Ward's example, in the original OOPSLA report, is that paying down the
technical debt was made easier by having a good object-oriented
system. Technical debt is not writing bad code. You
need good code in order to address technical debt:

> I'm never in favor of writing code poorly, but I am in favor of
> writing code to reflect your current understanding of a problem even
> if that understanding is partial.

The fact that it's well written code is what allows you to address the
misunderstandings you've baked in to the system. If you don't
understand how to program, then you've got two problems: cruft _and_
the technical debt you've incurred.

---

## Working notes

<iframe width="560" height="315"
src="https://www.youtube.com/embed/pqeJFYwnkjE?si=jhw11ZBhU_rYNqkT"
title="YouTube video player" frameborder="0" allow="accelerometer;
autoplay; clipboard-write; encrypted-media; gyroscope;
picture-in-picture; web-share"
referrerpolicy="strict-origin-when-cross-origin"
allowfullscreen></iframe>

> it was important to me that we accumulate the learnings we did about the application over time by modifying the program to look as if we had known what we were doing all along
https://wiki.c2.com/?WardExplainsDebtMetaphor#:~:text=it%20was%20important%20to%20me%20that%20we%20accumulate%20the%20learnings%20we%20did%20about%20the%20application%20over%20time%20by%20modifying%20the%20program%20to%20look%20as%20if%20we%20had%20known%20what%20we%20were%20doing%20all%20along




[Ward Cunningham - 5 minutes
video](https://www.youtube.com/watch?v=pqeJFYwnkjE)
Ward's corrective video

[transcript](https://wiki.c2.com/?WardExplainsDebtMetaphor)

[The WyCash Portfolio Management
System](https://c2.com/doc/oopsla92.html)
Ward at OOPSLA explaining technical debt for the first time

[A Mess Is Not Technical
Debt](https://sites.google.com/site/unclebobconsultingllc/a-mess-is-not-a-technical-debt)
Robert C Martin

[Technical Debt
Quadrant](https://martinfowler.com/bliki/TechnicalDebtQuadrant.html)
Fowler

[Technical Debt](https://martinfowler.com/bliki/TechnicalDebt.html)
Also Fowler

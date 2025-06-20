---
title: "Pair Rotation is a Smell"
date: 2025-06-20 22:52:55
published: true
description: "Why rigid pair rotation policies can be counterproductive in software teams"
tags:
  - programming
  - pair programming
  - agile
  - team dynamics
---

It's Tuesday morning. Time for the daily stand-up. The cards are moved, updates given, and then comes the familiar, slightly awkward question: "So... do we rotate pairs today?"

A nervous energy fills the air. Perhaps you've had enough of working on a dry database migration for what feels like an eternity and you're desperate for a change of scenery. Maybe someone else has their eye on that shiny new third-party integration and wants a piece of the action. Or maybe you just want to find out how that database migration is *actually* working without having to interrupt the pair already on it.

But what if this whole ceremony isn't a sign of a healthy team, but a symptom of a deeper problem? What if, instead of being a pattern to emulate, it's actually a "smell" pointing to a fundamental flaw in our process?

### What is Pair Rotation?

First, let's be clear what we're talking about. Pair rotation is the practice of swapping developers at a regular cadence, usually every day or two. Imagine Alice and Bob are working on a story to "Implement OAuth Login". At the same time, Charlie and Dana are tackling "Display User Profile Picture". If the team rotates pairs on Wednesday, you might see Alice pairing with Dana to continue the OAuth work, while Charlie and Bob pick up the profile picture story.

And why do teams do this?

### The Bus Factor

The argument for the practice is compelling and boils down to one critical metric: the "bus factor."[^1] The bus factor is a stark measure of risk: how many team members would have to be hit by a bus before critical knowledge is lost and the project grinds to a halt? If only one person understands the payment gateway, your bus factor for that component is one—a catastrophic vulnerability. All the other perceived benefits of rotation—sharing knowledge, fostering collective ownership, cross-pollinating ideas—are really just means to an end. That end is to increase the bus factor by systematically spreading context, ensuring the team is resilient and no single developer is a single point of failure.

(I sincerely hope that you don’t get hit by a bus. I hope you win the lottery instead. Much nicer for you. Same effect on the team though).

This all sounds great, right?

### So what’s the problem?

The argument for rotation seems sound, but think about the underlying assumption. Rotating pairs only makes sense if stories regularly last longer than your rotation cadence. If you're swapping pairs every two days, you are implicitly admitting that your stories frequently take more than two days to complete.

And *that* is the real problem. The need for pair rotation is a smell that indicates your stories are too big. It's a failure in the analysis function of the team.

### The Real Goal: Aggressively Small Stories

We shouldn't be optimising for knowledge sharing on long-lived stories. We should be optimising for stories that don't live long enough to need knowledge sharing. The real goal should be to make our stories so small that they can be completed, from picking them up to getting them into production, in less than two days. Preferably in less than one. Preferably in a few hours. Preferably 20 minutes with a coffee break.

This isn't a fantasy. It's an achievable discipline. Through aggressive scope-cutting in exercises like example mapping, and by breaking up features with exercises like story mapping, we can slice work into incredibly thin, vertical slices of value. The question should always be, "What is the absolute smallest piece of value we can deliver right now?"

When you make that your primary focus, the entire dynamic of the team changes.

### Small is Beautiful[^3]

Chasing this goal of radically small stories isn't just about avoiding pair rotation; it unlocks a cascade of benefits that improve the entire development process:

* **Smaller Mental Context:** A developer only needs to hold a small, well-defined problem in their head. The cognitive load is dramatically reduced.
* **Faster Delivery of Value:** This is the most obvious one. More frequent, smaller releases mean the business is seeing a continuous return on its investment.
* **Reduced Complexity & Risk:** Smaller changes are inherently less risky. They're easier to understand, easier to review, and easier to roll back if something goes wrong.
* **Effortless Reprioritisation:** You never have to "stop" an in-flight story to work on something more important. You just finish the tiny thing you're on and then pick up the new priority.
* **Reduced Merge Conflicts:** If you are still merging whole features in as pull requests (and you really shouldn't be because, for very similar arguments, you should be doing Trunk Based Development[^2]), then smaller stories reduces the potential for merge conflicts.
* **Faster Feedback Loops:** It's not just about delivering value faster; it's about *learning* faster. A small story can be deployed, and you get real feedback—from users, from performance monitoring—almost immediately.
* **Increased Team Momentum:** There is a powerful psychological boost for a team that is constantly finishing and shipping work. It builds momentum and avoids the morale drain of a story that drags on for a week.

### A Better Model for Knowledge Sharing: Organic Pairing

So what happens to knowledge sharing in a world of one-day stories? It doesn't go away; it becomes more effective.

When stories are small, a pair finishes their work quickly. They are now free. They go to the board, pull the next highest priority story, and form a new pair. Maybe one of them stays to provide context to a new joiner, or maybe two completely different developers tackle it.

The pairing becomes organic, fluid, and continuous. Knowledge isn't shared in disruptive, scheduled chunks; it's shared in a natural flow. The "bus factor" is reduced not by a contrived rota, but by the sheer velocity of shared experiences across the entire team. You don't need to force developers to learn the system; they learn it by constantly working on different small parts of it.

### Pairing Promiscuously

Let's be clear: arguing against scheduled rotation does not mean you should have fixed pairs. Far from it. The goal is still to have everyone on the team pair with everyone else. Tools like a "pair stair"—a simple matrix showing who has paired with whom—are great for visualizing this and ensuring no one is left out.

While having small stories helps avoid siloing knowledge about *the code*, it doesn't solve the problem of sharing knowledge and experience of *technique and engineering principles*. That's best done by making sure you pair promiscuously. Every developer has a different background, different tricks, and a different way of thinking. Pairing with all of them is how you grow as an engineer.

But you shouldn't need a rigid, scheduled rotation to do that. A healthy, fluid, organic pairing model naturally accomplishes this goal.

### Treat the Disease, Not the Symptom

Pair rotation is a well-intentioned band-aid applied to the wound of oversized stories. It tries to solve the problem of knowledge silos, but it ignores the process failure that creates those silos in the first place.

Stop treating the symptom. Focus on the disease.

Challenge your team. Make it a primary goal that no story is large enough to survive for more than two days. Be ruthless in your story slicing. See what happens to your flow, your team's morale, and your need for a rotation schedule. I suspect you'll find it simply melts away.

---
[^1]: The "Bus Factor" is a well-established concept in the software industry. For an authoritative reference, see "Software Engineering at Google" (Winters, Manshreck, and Wright, 2020), Chapter 2.

[^2]: Trunk Based Development is the practice of having all developers commit to a single shared branch (the 'trunk', or 'main'). For a comprehensive guide, see trunkbaseddevelopment.com.

[^3]: The benefits of small stories (or small batch sizes) are a cornerstone of modern software development, supported by multiple methodologies:

    * **Extreme Programming (XP):** The practice of "Small Releases" is core to XP, advocating for releasing the smallest increment of value to get rapid feedback. See Ron Jeffries' article "Getting to Small Stories".

    * **Lean & DevOps (DORA):** The book "Accelerate" (Forsgren, Humble, and Kim, 2018) provides years of statistical data showing that small batch sizes are a key predictor of elite-performing teams, directly improving throughput and stability.

    * **User Story Best Practice (INVEST):** The INVEST acronym, created by Bill Wake, provides a checklist for good user stories. The "S" stands for "Small," highlighting its importance. See Mike Cohn's "User Stories Applied" for a detailed breakdown.

    * **Product Development Flow:** Don Reinertsen's "The Principles of Product Development Flow" makes a powerful economic case for why reducing batch size is critical for reducing queues and improving overall development speed.

---
title: Continuous Integration is not a Server
description: The true integration is of our minds
published: true
date: 2024-07-05 22:52:55
---

What does it mean to integrate continuously?

Two branches in a version control system, each containing new features. In isolation. We pull them together - we merge them. We get a merge conflict. We resolve the conflict - we say which parts will stay and which will go. We integrate the two branches. We end with a single system.

But why was there a conflict?

Two developers, working on two features, in isolation. Headphones on, hacking away on their branches. One thought that the code should look _this_ way. One thought the code should look _that_ way. Conflicting views, different opinions, of how the system should be developed. Now both opinions are formalised in the code that makes up the system. We try to bring the code together, but there is a conflict. Yes, the lines of code are conflicting, but beneath this are the conflicting ideas of each developer on how the world they’re building together ought to look.

Is conflict inevitable?

Two developers, pairing on a feature. One thinks the code should look _this_ way, one thinks the code should look _that_ way (I don’t care who’s right or wrong). But there’s one program in front of them both, one monitor, one keyboard. Both opinions can’t be written into the code. There is a conflict. A discussion, an argument. A compromise, or perhaps some convincing. Even some learning. Outside help is sought from experts with experience. However it happens, there is resolution. One shared view of how the world should look now becomes codified in the system we are writing.

Is everything resolved?

One developer leaves the pair - pair rotation. Here comes a new developer. They look at the code. They have a different opinion - it shouldn’t look like _this_ it should look like _that_. They are very convincing, and so the pair changes the code to fit the new opinion they have formed together. Later they go to a code review with the team, and the original opinion from the first pair meets the new opinion - why does it look like _this_ now, what was wrong with looking like _that_? The whole team gets involved. More discussion, arguments, convincing, listening. A new resolution is reached - even if it’s just we don’t care what it looks like, or we’ll look at it again next week.

Are these the only things that need resolving?

A day later the user experience expert uses the program. It shouldn’t look like _this_, it should look like _that_. How could you have missed this? What are we, mind readers? The developers discuss this conflict with them. A resolution is reached and the developers go back and do some more work.

A week later the quality assurance expert reviews the deployed software. They find a bug, they think it’s a bug. They think the program should work like _this_ but instead it works like _that_. How could you have missed this? What are we, mind readers? They have a conversation with the developers, a conflict, a discussion. The developers go back and fix the bug.

A week later the product owner uses the program. It’s not meant to work like _that_ it’s meant to work like _this_. How could you have missed this? What are we, mind readers? There is a conflict, a discussion, a resolution. The developers go back and implement the vision for the product.

How early can we resolve conflicts?

A whole team of developers, mobbing on a feature. One codebase in front of them all. One monitor, one keyboard. The product manager is there. The quality assurance expert is there. The business analyst is there. Everyone is there as the program they’re all building together is written. There is a conflict. There are _lots_ of conflicts. Programmer conflicts - I thought we should write it like  _this_ not _that_. But other conflicts too. No, wait - you missed a test case, we need to cover what happens when the user does _this_ and then _that_. _Stop!_ That’s not the right colour. I thought the business rule was _this_ but you think it’s _that_. But now there’s the product owner in the room, and they know - it’s _this_ way. Or the business analyst will then say _what?_ I thought it was like _this_ not _that_. And there will be a conflict, and perhaps someone will go out of the room and get an expert to come _right now_ because this is blocking a whole expensive room full of developers doing this important work. But there will be a resolution, and every single person in the room will have a much more shared idea of _everything_, the code, the tests, the way it should look and how it’s meant to work.

And then there are no more conflicts?

Someone reads a book, goes to a conference, reads a blog post. Wait there, we shouldn’t do it like _that_, we need to do it like _this_...

---

The true continuous integration is the continuous integration of my mind with your mind, my opinions with your opinions, my style  with your style, forced to be integrated into the _single_ piece of code we’re working on. Code is unforgiving of ambiguity in every way. Writing it, bringing everyone’s ideas into a single place, is the source of all conflict.

We can defer this conflict to pull requests, and continuous integration servers. This can _feel_ efficient because everyone gets to live in their own vision of the world. I always feel like a much more efficient developer when I’m not talking to anyone. But these are _discontinuous_ forms of integration because they defer all the conflicts to the merging of the code. Compare it to pair programming and mobbing, where the conflicts are resolved as the code is written, where each mind tries to share its ideas with the others as they attempt to resolve the conflicts in their ideas for the program, and create a shared vision.

Even worse forms of integration exist between the different disciplines. If developers only communicate with a QA after the story has been delivered then the new ideas about bugs and testing will have to be added to the code right at the end, rather than right at the beginning if they were in the room coding, or discussing the work with the developers at the beginning.

If the product owner expects everyone to share their vision, but only communicates requirements through written specifications and tickets, then they are asking to be disappointed with what’s delivered. The earlier they can resolve conflicts and misunderstandings when the program is developed, the happier everyone will be.

This is not always possible. Each developer has other responsibilities and it will often not be efficient to have a product owner sitting constantly in the same room as all the developers. But we shouldn’t shy away from saying that this would be the optimal way to write software to reduce conflicts.

This requires trust. Confidence that each team member is acting in good faith to try to build the best program they can. Compromise because not everyone can be right all the time. Flexibility because good new ideas will arrive and should be tried out. This level of integration requires the openness that everyone talks about when discussing a high-performing team.

_Continuous_ integration, if we take the idea seriously, requires us to find and address every conflict in the team as early as possible.

Because the true integration is not the integration of code.

It is the integration of our minds.

---

Dedicated to Chris James.

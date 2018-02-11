---
layout: post
title: "Method length: a good metric, a bad target"
date: 2017-08-07 17:09:53
tags:
    - Theory
    - Craftsmanship
published: false
---

So I saw this series of tweets a few days ago

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Pro tip: if your method is 225 lines long, then you should probably refactor your code ASAP. I frown at methods over 50 lines.</p>&mdash; Anna Filina (@afilina) <a href="https://twitter.com/afilina/status/892802260283076608">August 2, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">IMO ten is too long in most cases. <a href="https://t.co/ayPb9Ly76I">https://t.co/ayPb9Ly76I</a></p>&mdash; Ron Jeffries (@RonJeffries) <a href="https://twitter.com/RonJeffries/status/893071198401290240">August 3, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">In my Ruby code, half of my methods are just one or two lines long. 93% are under 10.<a href="https://t.co/Qs8BoapjoP">https://t.co/Qs8BoapjoP</a> <a href="https://t.co/ymNj7al57j">https://t.co/ymNj7al57j</a></p>&mdash; Martin Fowler (@martinfowler) <a href="https://twitter.com/martinfowler/status/893100444507144192">August 3, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Always nice to see an escalation.

Martin's article on the Bliki is nice, but I think it's still missing the point.

> Small functions like this only work if the names are good, so you need to pay good attention to naming.

Short methods are good -> but they are hard to name, so work hard on the names...

Is this accurate? It almost feels like we're putting the cart before the horse.

Here is a piece of code I can extract -> Here it is on its own -> What the hell do I call it?

This chimed with something I saw in the SICP lecture course.



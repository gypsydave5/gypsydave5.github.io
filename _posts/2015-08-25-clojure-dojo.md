---
layout: post
title: "Clojure Dojo"
date: 2015-08-18 20:39:14
tags:
  - Learnings
  - Clojure
published: true
---

I've just got back from [Clojure Dojo][Clojure Dojo] over at the
[Thoughtworks][Thoughtworks] offices in Soho.  The Clojure Dojos have been run
by the [London Clojurians][LdnClj] for about five years now and are still going
strong. I've been meaning to go to one for a while, and tonight the stars were
right.

What's a Clojure Dojo? Developers gather in a room full of pizza[^1] with
computers and chat about which editors they use.[^2] Then someone very sensibly
says we should probably start.

First we introduce ourselves, tell everyone how much we know about Clojure and
what the first language we learned was.[^3] There were a good mix of people in
tonight, a few who had been doing Clojure for years, many for months, and a few
like me who have been dabbling their toes in the water for a while. I was
heartened to see a Maker there who had graduated on Friday - that takes some
guts and enthusiasm.

Then we pitch ideas to hack on for the evening. They were all great ideas, from
Conway's Game of Life to Google Maps plugins that show extinct species. The
winner was a Twitter Markov Generator - an awesome idea that generates new
tweets based upon a history of tweets, picking the next word based upon the
likely hood that it follows from the previous word in the history.

We were split into random groups of 3-4 and - just got on with it.
After about two hours the teams gathered together once more to show off their
(completely unfinished) products. Then we all went home.

The subject sounded fairly dry to me, but it turned out to be plenty to get my
teeth stuck in to - I'd almost recommend it as a kata. I was working with three
other devs - Fabio, who'd been working on Clojure for about a year and had the
most wicked Emacs/Cider[^4] set up that was a joy to watch him code with. There
was also Francis who had been looking at Clojure 'for about two weeks', but had
a Lisp background that just shone through. And happily we also had
[Chris][Chris], the convener of the Dojo who had been working in Clojure for
four years or so. He helped a lot, and was great to chat with about practices,
concepts and the style of Clojure.

I learned a lot in a short space of time, refreshing my brief exposure to the
language quite quickly.[^5] But the best bit was when we planned the data structure.
Initially we were looking at nested hash-map arrangement, with the inner map
indicating the percentage chance of each next word - something like:

```clojure
{ "Word" { "nextWord1" 1, "nextWord2" 10, "nextWord3" 79} }
```

But then Francis suggested that we just hold a list of a hundred words
that represented the probability distribution:

```clojure
{ "Word" ["nextWord1"
          "nextWord2" ;; ten times
          "nextWord3"] ;; eighty odd times
}
```

To which I responded that we may as well just collect up all of the next words
and randomly sample from it. I thought this would make everyone go 'oh, but
that'd be too long' but, no, everyone liked it. So massive, massive vectors it
was.

My next favourite moment was when I wondered whether we'd be slowly feeding the
tweets in one by one to a function to build the hash-map. No, Fabio (I think)
said - we'll just combine them into one giant string and feed it in.

One. Giant string. Of all the tweets. Mind blown. Not quite big data, but I loved
the epic processing powers it felt like we were harnessing - lightning of the
gods and all that good stuff.

I discovered is all my practice in functional languages over the last few months
means that I can put together a recursive function pretty quickly and
accurately. Unfortunately I also discovered I can't come up with a decent name
when typing - and I also found out that there's little appetite for a refactor
in a Dojo.  That function's name is my eternal shame.[^6]

We had something fairly decent by the end of the Dojo. More exiciting was seeing
what the other teams had produced. One team had made this glorious and terse
looking almost one liner (and it really could have done with being put on a few
more lines) that seemed to have more functionality than I could believe. Another
team practiced their TDD[^7] and also created and elegant 'word shifting' move
that provided the word-nextWord pairs without any recursion. And the final team
wrote no code per se, but spent a productive few hours setting up a Clojure
project and investigating the useful libraries that could help in the project.

I feel that I could see more of what the fuss about Clojure was about. Each team
had thought about the nature of the data they were going to create and
work on, linking it to the functions they were using to translate the input into
the output. The beauty came in the diverse implementations, both in data and
functions, and just how terse yet expressive both were. It's left me wanting
more.

A friendly atmosphere, enthusiastic programmers, a great language and problem to
play with - and did I mention the pizza? I'm already looking forward to the next
one.

Many, many thanks to [Chris Ford][Chris] for organising and Thoughtworks for
hosting!

[^1]: This is a widely used pattern that has proven highly performant in all languages... 😉
[^2]: Developer smalltalk equivalent of 'how did you travel here?'
[^3]: One ML and one Turbo Pascal. Nice.
[^4]: I've also started to use Emacs - see the next footnote.
[^5]: I've been doing a lot of Lisp recently, which I'll get to blogging about soon enough.
[^6]: `reduce-sum` - seriously? It wasn't even summing anything 😢🐼
[^7]: I'm not even going to get into whether we should have been TDDing or whether the repl can cover some of those requirements. I'll call it a massive spike for now and move on to TDDing it when I do it again.

[Chris]: https://twitter.com/ctford
[Clojure Dojo]: http://www.londonclojurians.org/dojos.html
[Thoughtworks]: www.thoughtworks.com
[LdnClj]: www.londonclojurians.org


---
layout: post
title: "Book Review: Clojure for the Brave and True"
date: 2017-07-26 11:43:59
tags:
    - Reviews
    - Clojure
    - Books
published: true
---

One line review: [_Clojure for the Brave and True_][braveClojure] by
[Daniel Higginbotham][dhig] is a pretty good intro to Clojure, if you can get
past the undergraduate humour.

_Clojure for the Brave and True_ could be thought of as a part of a loose
trilogy of books, including [_Land of Lisp_][LoL] and [_Realm of
Racket_][RoR],[^1] that explore modern Lisps in a light hearted way with
cartoons.

The first problem with this comparison is that _Brave & True_ is nowhere near
as good as _Land of Lisp_ - Barski's jokes are funnier, his cartoons are better,
the content is both deeper and broader. _Land of Lisp_ has
a chapter called "Let's build a Web Server from Scratch" and it's not lying.
Whereas _Brave & True_ won't even show you the ropes on something like
[Compojure][compojure].

The best chapters in _Brave and True_, which are also the most useful ones, are
the ones where you're being walked through a piece of code line by line. The
'[Peg thing][peg]' game is a great example of a interactive command-line game
written using a series of pure functions. This chapter gives you a real idea of
how to get some Clojure code doing stuff in the world - a practical toolkit to
let you get writing something.

The other great thing about this book is its opinionated introduction to
editors. I struggled mightily setting up something to do my Lisps in,
having gone through a variety of Vim and Emacs setups with every damn plugin you
can imagine. _Brave and True_ has [an entire chapter dedicated to getting
a decent Emacs environment][emacs] (you can download the configuration),
complete with Cider and Paredit. It's not going to teach you everything you want
to know, but once you're done you will be immediately productive and able to get
along with the more serious task of actually writing some Clojure.

But I often found the sense of humour in this book grating. It is as if I was
forced to hang around with my fourteen-year-old self.[^2] The one who'd
memorized a lot of _Monty Python_ and _The Hitchhiker's Guide to the Galaxy_ and
thought that quoting it back at my friends was the height of sophisticated
humour. The examples feel contrived to fit the humour, often to the detriment of
the point that is trying to be made.

The poorest chapters are the ones where an idea is introduced but not fully
explored. When introduced to protocols and records it would be nice to
understand how they are used to leverage polymorphism in something more
practical than the contrived Richard-Simmons-as-Werewolf examples that felt even
less useful than the usual Object Oriented Guide to Animal Taxonomy we're forced
to endure.

_Brave and True_ is a good book, and is worth buying and reading (and if you
want to sample the content it's all available on [the book's excellent website][braveClojure]).
It's filled me with confidence to write Clojure (probably before other
languages) and to read more books on Clojure.  I just wish that it had spent
less time crapping around with spurious examples and more time showing me how
and why Clojure is the best.

Now I'm going to read [my favourite introduction to Lisp][lispcartoon] again
(keep scrolling) and maybe finish _Land of Lisp_.

[^1]: Guess they couldn't find an appropriate name for an area starting with 'C'. _Castle of Clojure_? _Continent_? _Cave_?
[^2]: Bah, OK. My 20 year old self too. I can still sing all of _The Philosophers' Song_, I just know I shouldn't.

[braveClojure]: http://www.braveclojure.com/
[dhig]: https://twitter.com/nonrecursive
[compojure]: https://github.com/weavejester/compojure
[lispcartoon]: http://landoflisp.com/
[peg]: https://www.braveclojure.com/functional-programming/
[emacs]: https://www.braveclojure.com/do-things/
[LoL]: http://landoflisp.com/
[RoR]: http://realmofracket.com/


---
layout: post
title: "Clojure on the Tube"
date: 2015-05-18 20:39:14
tags:
    - Learnings
    - Tools
    - Clojure
---

Thought I should share this, as it surprised me. I solved one of
the [4Clojure] problems on the London Underground today while commuting home,
using my smart phone.

I didn't think it would be possible to write anything useful on such a small
device, but with a bit of persistance I was not only able to write some Clojure,
I was also able to run it inside a REPL to see what I was doing wrong and
iterate on my solution.

If you've got an Android phone the REPL I used was [Clojure REPL] and the
local instance of the 4Clojure problems were held on the [4Clojure app]. Both
apps are pretty nifty. The only thing that slowed me down was trying to type all
those parens on the native keyboard.

4Clojure is good resource of problems to help learn Clojure; I've been getting
rusty recently as my main focus has been JavaScript. And planning my wedding.

For the record, this is the function I wrote:

```clojure
(fn flatn [lst]
  (if (coll? lst)
    (apply concat (map flatn lst))
    [lst]))
```

Note that this was done at the north end of the Victoria line, near Finsbury
Park. I don't think I'd have managed it on the Northern line in the City...

[4Clojure]: http://www.4clojure.com/
[Clojure REPL]: https://play.google.com/store/apps/details?id=com.sattvik.clojure_repl
[4Clojure app]: https://play.google.com/store/apps/details?id=org.bytopia.foreclojure

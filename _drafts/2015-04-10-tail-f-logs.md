---
layout: post
title: "Logging with `tail -f`"
date: 2015-04-10 18:34:47
tags:
    - Tools
    - Unix
published: false
---

New and exciting Unix commands just keep on cropping up - the latest is a great
way to monitor multiple application's logs while they're running - and
preferably without running them all in separate consoles.

First you need to send the standard output and error for each service to a file
- Ruby can take care of that with `Process.spawn` with the handy `:out` and
`:err` options, but there are similar methods available in Node. Or even bash.

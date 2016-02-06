---
layout: post
title: "Logging with `tail -f`"
date: 2015-05-22 22:05:21
tags:
    - Tools
    - Unix
    - Microservices
    - Bash
published: true
---

Debugging a series of microservices locally can be a pain. You need to see all
of the logs for each service, live, and hopefully all in one place to save you
time trying to work out what's going on at the same time.

You could run each service in a separate terminal, but that doesn't help manage
reading the logs at once and doesn't scale well. Alternatively the services can
be run in the background and we could send their output to the same terminal.
But that is going to look messy - how will we know which service is logging?

So let's send STDERR and STDOUT to a couple of files - we can do this in
whatever we use to launch the services, but in bash it looks something like this:

```bash
run_service > service_name.log 2> service_name.err &
```

Now we've got a lot of files, slowly filling with logs. But we're definitely not
reading them all at once. Enter the hero of the piece, `tail -f`. `tail` is
a nice little Unix command that has the standard behaviour of reading the last
10 line of a file. Handy now and then, but no big deal. `tail -f`, though, is
a superhero. It "causes tail to not stop when end of file is reached, but rather
to wait for additional data to be appended to the input" (I'm quoting straight
from the `man` page).

What that means is that `tail` waits for more lines to be added to the file, and
prints them when they are. Live logs are back - but only for one file. But
`tail` has another neat feature: reading from multiple files. Just put them all
in as arguments or splat them with a `*` like `tail -f *.log *.err`.

Which has this lovely looking output:

```bash
==> service_one.err <==
Here are some errors from service_one

==> service_one.log <==
And here are some logs from service_one

==> service_two.err <==
With the same deal...

==> service_two.log <==
... for service_two

```

And just carries on outputting as your services run, letting you keep an eye on
all of them at once while you get back to work.

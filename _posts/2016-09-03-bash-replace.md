---
layout: post
title:  "Fixing your last bash command"
date:   2016-09-03 19:49:37
categories: bash
published: true
---

Guy I know -  Oliver - command line _ninja_. Never makes a mistake. Can
configure an AWS in a single long bash command. Typing speed through the roof.
Bet you know someone like that too.

We mere mortals make mistakes and, while it's always good to learn from your
mistakes, the first thing you have to do is _fix them_.

And to fix them you need to learn how to fix them.

## Simple replace

Say you've typed an impossibly long command into the terminal with one
irritating mistake. For me, it's usually something to do with `xargs` or `curl`

```bash
  curl -s -I -X POST https://en.wikipedia.org/wiki/CURL | grep HTTP | cut -d ' ' -f 2
```

Not the greatest command - but say I couldn't spell wikipedia...

```bash
  curl -s -I -X POST https://en.wikpedia.org/wiki/CURL | grep HTTP | cut -d ' ' -f 2
```

### First solution: up and left

Naive, and effective. Press up to show the last command, keep tapping left until
you get the the bit of the command you need to change, backspace to remove what
you don't need and then enter what you do need

### Second solution: bash vi mode

Bash has a vi mode, which can be activated by adding the following to your
`.bashrc`.

```bash
set -o vi
```

If you're comfortable with vi you can now hit `Escape` to bounce into normal
mode, `Ctrl-P` to go back to the last command, `b` a few times to get to the
word you need to change... etc.

Vi mode is great - if you know a bit of vi. But you might not. So...

### Third solution: quick substitution

How about something a little smarter:

```bash
^wikpedia^wikipedia
```

This is the bash [quick substitution][quickSub] history expansion command - it
runs the last command, substituting the first instance of the charaters after
the first caret with the characters after the second caret.

Pretty neat huh? But that will olny work for the first instance - what if we
need to replace every instance of `wikpedia` in the last command?

### Fourth solution: full history substituton

Bash uses the `!` character as the [history expansion][histExp] character - it
is used to substitute a part of your current command with a previously executed
command[^1]. One `!` does nothing - but the previous command can be accessed with
the `!!` sequence. So, to print out the last command, try:

```bash
echo !!
```

These history expansions can also take [modifier][histMod] options to change the string
before it gets inserted. The syntax is `<select>:<modifier>`. For instance, to
put the last command in quotes:

```bash
echo !!:q
```

And to perform a global substitution on it:

```bash
echo !!:gs/wikpedia/wikipedia
```

There is lots that can be done with the above syntax - just take a look at the
documentation.

### Fifth solution: retype the command

Seriously, by the time you've remembered how to do some of the above, wouldn't
it have just been easier to type it out again.

Just don't mess it up this time, right?


[^1]: And this is the reason I have to escape `!` whenever I use it in commit messages
[quickSub]: https://www.gnu.org/software/bash/manual/html_node/Event-Designators.html#Event-Designators
[histExp]: https://www.gnu.org/software/bash/manual/html_node/History-Interaction.html#History-Interaction
[histMod]: https://www.gnu.org/software/bash/manual/html_node/Modifiers.html#Modifiers


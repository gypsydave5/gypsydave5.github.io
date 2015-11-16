---
layout: post
title: "Backing up your Homebrew packages"
date: 2015-10-16 20:39:14
tags:
  - Mac
  - Tools
  - Unix
  - Text
published: true
---

_Update: while this is a good template to do a quick backup, a more flexible solution exists in the
[Brew Bundle](https://github.com/Homebrew/homebrew-bundle) project. Thanks [@MacHomebrew](https://github.com/Homebrew/homebrew-bundle) for the pointer!_

It's a good idea to keep track of what packages you've got installed in
Homebrew - good for provisioning a new Mac, good for recovering from a disaster.

To get a list of the current packages is as simple as

```bash
brew ls
```

but that gives us everything, dependencies and all. If we just want what we
explicitly installed, we should go for

```bash
brew leaves
```

like the leaves of our dependency tree.

Just pipe that out into a file

```bash
brew leaves > homebrew-packages.txt
```

for safekeeping and get it under version control along with the rest of you
configuration files.

When it comes to recovery, we can save time and effort by using `xargs` to pipe
out each of the lines as an argument to `brew install`

```bash
cat homebrew-packages.txt | xargs brew install
```

and everything will (re)install in one go. It may take some time.

Maybe you want to add to the list from one machine without overwriting the
current list? I just did (for one reason or another), and it's fairly easy to
handle. Instead of overwriting the text file, append to the end of it

```bash
brew leaves >> homebrew-packages.txt
```

Now you might have some repetitions in that file - get rid of them with

```bash
sort homebrew-packages.txt | uniq
```

This sorts the original list into order, then removes any lines that are
repetitions of the one before, leaving only one. Pipe that out to a new file

```bash
sort homebrew-packages.txt | uniq > homebrew-packages-reconciled.txt
```

and overwrite the old one if you need to (just don't do it in the pipe - it
doesn't like it and the file becomes blank. Boo.)

Did I mention that [Text Processing with Ruby][review] was an amazing book?
I worked out how to do the above from what I read in the section on
Unix tools. Nice.

[review]: {% post_url 2015-10-07-text-processing-with-ruby-review %}

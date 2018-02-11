---
layout: post
title: "Pre-commit Hooks in Git"
date: 2016-02-20 21:08:41
tags:
    - Git
published: true
---

Remembering to run your tests before you commit is hard:

```bash
* 84f7e2e 2016-02-06 | Another typo. And test[David Wickes]
* ef215f8 2016-02-06 | OMFG semicolons WAAAAAT [David Wickes]
* c20b65d 2016-02-06 | Typo [David Wickes]
* fca4aa8 2016-02-06 | Another fix for the same test[David Wickes]
* f0206a9 2016-02-06 | Fixes failing test [David Wickes]
* 657cc48 2016-02-06 | Amazing new feature [David Wickes]
```

Yes, I suck. It's even worse when you've just pushed that _teensy-tiny,
insignificant_ change to the CI pipeline and it throws a strop because the JS
linter is _super_ fussy about semi-colons.

Don't get angry. Get even.

Wait, wut? Don't get even. Automate all the things!

Inside the unexamined recesses of the `.git` directory of every repo
is a folder called `hooks`. You should look inside it.

```bash
applypatch-msg.sample
commit-msg.sample
post-update.sample
pre-applypatch.sample
pre-commit.sample # <--- This one here!
pre-push.sample
pre-rebase.sample
prepare-commit-msg.sample
update.sample
```

You'll see some pretty self-explanatory instructions on what it does, but the
tl;dr is:

- It is a shell script that runs before you commit
- You activate it by removing the `.sample` bit.

So say we have a Node project we're working on. A cool pre-commit hook would
look like:

```bash
#!/bin/sh

npm test
```

Pop that in a file called `pre-commit` inside that `hooks` directory - make sure
it's executable like the sample ones - and see what you get.

So as long as you've set up you `package.json` file sensibly to run tests when
you run `npm test` you're golden. Same idea holds for `rake` or `gradle` or
whatever you're using as a task runner.

But you'd hate to do that for every project, right? Automate that too.

Try this:

```bash
$ git config --global init.templatedir '~/.git-templates'
$ mkdir -p ~/.git-templates/hooks
```

Inside the equally unexamined `.gitsettings` in your home directory you should
now see:

```
[init]
    templatedir = ~/.git-templates
```

(you could've just written that in there by hand... but here we are)

What this'll do is copy the contents of `.git-templates` to the `.git`
directories of new projects you clone or initialize.

We now need to make our hook more generic. Let's save the below off in
`~/.git-templates/hooks/pre-commit`:

```bash
#!/bin/sh

if [ -f package.json ]; then
    echo "detected package.json... running npm test"
    npm test
else
    echo "no testable project detected... so no tests before commit"
fi
```

`[ -f package.json ]` asks if there's a file called `package.json`, and if there
is we run `npm test`. The rest of the script is just a little logging so we can
see what's happening. Just remember to make it executable[^1] before you start to
use it.

There we have it - the bare bones of a "generic" pre-commit hook. You can easily
embelish this with more tests and other exciting/useful/amusing things to
execute (is there a `Rakefile` present? Do any of the files I'm commiting still
contain a `console.log` or a `puts`?).

As I said, this template will get added to everything that gets `clone`ed or
`init`ialized by Git from now on. For those projects that have already been
started, just run `git init` again to pull in the template.

And there we are - have fun exploring the other sample templates, [read the
docs][docs], and experiment with other useful scripts. Then tell me about them
on Twitter so I can use them.

[^1]: `chmod a+x pre-commit` - you didn't need telling, but just in case.
[docs]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks


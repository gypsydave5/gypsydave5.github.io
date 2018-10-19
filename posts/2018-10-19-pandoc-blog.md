---
layout: post
title: "Write and deploy a blog in less than thirty seconds"
date: 2018-10-19 15:18:43
tags:
  - pandoc
  - now
  - unix
  - blogging
published: true
---

What's the fastest way to start a blog? Wordpress? Jekyll?

Nah, it's `pandoc` and `now`.

## What's `pandoc`?

[Pandoc][pandoc] is a 'universal document converter' - a swiss army knife for
changing document type a into document type b. It's good for lots of things, but
today it's going to be good for turning Markdown (what we like writing in) into
HTML (what we read on a website).

## What's `now`?

[Now][now] is a useful product from Zeit.com for deploying an application
_really_ quickly. It's great for throwing up something to see how it works. It
will serve up Docker images, NodeJS applications and static sites. Today, we use
it for a static site. You can install it with a simple `npm i -g now`.

## On your marks, get set...

So, make sure that you've got `pandoc` and `now` installed, that you're in
a nice clean directory and that you've got a connection to the Internet. And
that you know what your favourite editor is. If you don't have a favourite, pick
the one you hate the least.

## ... GO!

Quickly - open a file called `hello-world.md` in your favourite editor and write
something like this:

```
# Hello World

Hello world, this is the world's fastest blog!
```

Save it - faster, faster! And now run this in the terminal. What? I didn't tell
you to open a terminal session? Quickly, open one and run:

```shell
pandoc -o=index.html -to=html5 --standalone hello-world.md
```

IGNORE THE WARNINGS, we don't have time to explain! Now... SHIP IT!

```shell
now
```

`now` will put your `index.html` on the Internet. It'll even put the URL it
uploaded it to in your clipboard. Now, open your least hated web browser and
open the URL.

Success!

The other fifteen seconds is to bask in the glow of your achievement - you've
earned it.

## More?

What, you want more than one blog post in your blog? Are you crazy or greedy? Or
both? Such luxury, millenials are so spoiled and entitled yadda yadda yadda...

Sure! Try this: open a new file called `my-second-post.md` and write your second
post in it - I don't care what you write about!

Now write `index.md` - like this:

```
# My Quick Blog

- [Hello World][hello-world.html]
- [My second post][my-second-post.html]
```

and now

```shell
pandoc -o=index.html --to=html5 --standalone index-world.md
```

```shell
pandoc -ohello-world.html --to=html5 --standalone hello-world.md
```

```shell
pandoc -omy-second-post.html --to=html5 --standalone my-second-post.md
```

finally, once again

```shell
now
```

Paste the new URL in your browser and...

BOOM! You now have a blog with an index page and two posts. Do a little dance!

## Things you can now try out

- We're programmers - we don't like to do things twice! Write something to loop
  over the `.md` files in your directory to turn them into `.html` with `pandoc`
  rather than doing every file by hand. Bash, Ruby, JavaScript - whatever is
  easiest!
- It's not fun to have to change the URL of your blog every time you deploy it.
  `now` has a way you can alias a deployment to a permanent URL - why not take
  a look at how that's done.
- Your blog is _ugly_. Not going to lie. You should add some CSS. `pandoc` has
  a way to include a CSS file in the html - you need to add the flag
  `--css=file.css` to your `pandoc` call (once you've written some good looking
  CSS that is)
- Stop ignorning the warnings! Take a look at how to add metadata to your Pandoc
  markdown - it's all in the Pandoc documentation

Have fun

[pandoc]: http://pandoc.org/
[now]: https://zeit.co/now

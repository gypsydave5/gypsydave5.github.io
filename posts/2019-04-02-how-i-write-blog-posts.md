---
layout: post
title: "How I Write Blog Posts These Days"
date: 2019-04-02 21:26:15
tags:
- writing
- editors
published: true
---

## 1. Editor: Vim

I write my Markdown in Vim. Or Emacs in Evil mode, which is Vim emulation in
Emacs. Why? Well, I find the manipulation of text - any text - really quick and
easy in Vim. Moving paragraphs, changing words, deleting sentences - Vim is
aware of the structure of natural language, which makes using it to edit blog
posts quite easy.

## 2. Format: Markdown

Markdown is both wonderful and terrible. Wonderful as it's _everywhere_, is
human readable, and supports the structures you want to use for technical
writing - i.e. code blocks. Terrible because there is no standard and so the
HTML you'll get out of the other end of a parser is not consistent between
parsers.

Think this isn't too much trouble? I have to join all the lines in a paragraph
to a single line when I'm posting on Dev.to as the Markdown parser treats all
the line breaks in a paragraph as hard breaks.[^1]

It's this inconsistency in Markdown parsers that makes me avoid (or at least not
rely on) Markdown linters and previewers in my editors. I tend to wait until the
post is near finished before I see what it looks like with stage 5 (see below).

Still, the benefits outweigh the drawbacks and so Markdown it is.

### 3. Grammar and Spelling: aspell, style and diction

Markdown posts like this can be sent to [`aspell`](http://aspell.net/), a handy
interactive and extensible spellchecker. Good editor integration for aspell
exists in both Vim and Emacs.

[`style` and `diction`](https://www.gnu.org/software/diction/diction.html) are
a pair of tools that check for grammar mistakes and readability. `diction` picks
up on clichés, doubled-words and potential misspellings. It's _sometimes_ wrong
but it gets you thinking about whether you could word things better and so makes
an excellent starting point.

`style` describes how readable your document is through a series of scores
- [Flesch-Kinkaid](https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests)
for instance. It's interesting information.

### 4. Storage: GitHub

I keep my posts [on GitHub](https://github.com/gypsydave5/gypsydave5.github.io).
If someone spots a mistake in what I've written then at least this way they can
open a pull request.

### 5. My Site: Static Site + GitHub Pages

I've been using [GitHub Pages](https://pages.github.com/) to host my blog as
a static site since forever. It's an easy enough hosting solution and you can
use it with any number of static site generators to turn your Markdown into
HTML.

I wrote [my own static site generator](https://github.com/gypsydave5/blawg)
because I found every one I tried a little too busy for my liking. It's _still_
too busy for my liking and I reckon it could be scrapped in favour of
[Pandoc](https://pandoc.org/) and a few glue scripts, but it was fun to write.
I wouldn't use it if I were you.

I have a [horrible bash
script](https://github.com/gypsydave5/gypsydave5.github.io/blob/source/publish.sh)
to publish the blog, and it looks [like this](http://blog.gypsydave5.com/) when
it's published.


[^1]: Would be annoying if it wasn't for Vim's `J`oin command...

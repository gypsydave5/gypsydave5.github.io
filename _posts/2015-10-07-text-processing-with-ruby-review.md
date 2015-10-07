---
layout: post
title: "_Text Processing with Ruby_ Review"
date: 2015-10-07 20:39:14
tags:
  - Book
  - Ruby
  - Review
published: false
---

Things I've had to do since becoming a developer:

- Scrape a website for data.
- Search through logs. A lot.
- Create a JSON parsing command line tool
- Create a spreadsheet report from log files.

What these things have in common is the need to work directly with
plain text. Plain text is at the root of everything we can do as
developers - we read it, we manipulate it, we write it back out as
logs or files or HTML. We write it as code. It's the universal
interface and it's impossible to avoid.
[_Text Processing with Ruby_][bookSite] shows you how to do it as
quickly, and elegantly, as possible.

A standout feature is the book's use of UNIX command line tools. While
there are obviously ways to count the number of lines in a file in
Ruby, none are going to be as quick and as easy as `cat file.txt | wc
-l`.[^1] The beauty of this book is in the way it breaks down and blurs
the edges between command line tools, Ruby scripts and larger, more
organised programs.

Time is spent exploring the powers - and limits - of text processing
using tools like `cat`, `grep` and `cut`. We're shown the
possibilities of writing Ruby code straight into the command line
using the `-e` option of the `ruby` command. And as this builds up
we're then shown how to handle standard input and output inside ruby
programs, with the difference between `ARGV` and `ARGF` being well
explained.

In fact, for me this stuff is worth reading the book alone. Leveraging
forty years worth of basic text tool gets more done and
faster. Demonstrating how to pipe out of a process into `less` to read
output was one of the most amazing things I've seen done in Ruby.

Regular expressions are covered without bogging down in too much
theory, and with a strong emphasis on their practical application.
well. This, along with the introduction to using Ruby's system
variabes (the two character ones that start with `$`) has given me
some powerful tools to get text work done.

We're also given a fun tour of parts of Ruby I've not seen - ERB
templating (outside of a web framework), SimpleDelegator - and a few
deep dives on popular text parsing and processing libraries such as
the ever-present Nokogiri. Natural language processing and fuzzy
matching using Phrasie, Metaphone and Levenshtein indexes are shown
off too.

I've found [_Text Processing with Ruby_][bookSite] a great exploration
to playing with text - both inside and outside of Ruby. Reading
through its chapters has givem me more confidence to try new things
when solving problems. And it's sufficiently independent from Ruby for
me to apply what I've learned other languages I work in.

And that may be the biggest selling point of this book: it's a book I
can apply to my work _right away_ - I am literally using the things
I've learned at work today. Perfect for the beginner Rubyist, or
anyone who needs to just get things done with text.

_I was given a copy of this book to review._

[^1]: The author, [Rob Miller][authorName], gave an interesting example of the power availble in command line tools when I saw him speak at [Brighton Ruby], comparing the processing speed of Hadoop against a laptop's UNIX toolchain using small (~2GB) data sets. You can read more about this comparison on [Adam Drake's blog][BigDataCli].

[BigDataCLI]: http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html
[authorName]: https://robm.me.uk/
[bookSite]: https://robm.me.uk/text-processing-with-ruby/
[Brighton Ruby]: http://brightonruby.com/

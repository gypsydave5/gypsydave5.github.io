---
layout: post
title: "<em>Text Processing with Ruby</em> by Rob Miller"
date: 2015-10-07 20:39:14
tags:
  - Book Review
  - Ruby
published: true
---

Plain text is at the root of everything we can do as
developers - we read it, we manipulate it, we write it back out as
logs or files or HTML. We write it as code to do all that, and at the
end of the day we use it to write blog posts like this.
Rob Miller's [_Text Processing with Ruby_][bookSite] shows you how to
do it as quickly, and elegantly, as possible.

A standout feature is the book's use of command line tools. While
there are obviously ways to count the number of lines in a file in
Ruby, none are going to be as quick and as easy as `cat file.txt | wc
-l`.[^1] The book breaks down and blurs the edges between shell tools,
Ruby scripts and larger, more organised code in a really beautiful way.

We're shown tools like `cat`, `grep` and `cut`, and how to
interoperate them with Ruby code written straight into the command
line. And as this builds up we're then shown how to handle standard
input and output inside Ruby programs, allowing us to create our own
command line tools that will play nicely as a part of a pipeline with
the rest of the Unix tool chain.

For me this stuff is worth reading the book alone. Leveraging forty
years worth of text tools along side your Ruby code gets more done and
faster. The part of the book that demonstrates how to pipe out of a
process into `less` to generate paging output was one of the most
amazing things I've seen done in Ruby to date

Regular expressions are covered in greater depth than I have seen in
other Ruby books, and with a strong emphasis on their real-world
application. The book shows how to use Ruby's system variables (the ones
starting with `$`) to keep regex and other code short. Some people
(OK, my friend Andrea) dislike using anything starting with a `$` in
their code, and I can see their point as it can look a little esoteric
and obscure. But it felt right to me in the context of this book;
maybe you'd not want to use the system variables in larger, more
modular software, but they're perfect for the short, command line
scripts often used to process text.

We're also given a fun tour of parts of Ruby I've not seen - ERB
templating (outside of a web framework), SimpleDelegator - and a few
deep dives on popular text parsing and processing libraries such as
the ever-present Nokogiri and StringScanner. Natural language
processing and fuzzy matching using Phrasie and Text are shown off
too.

And that may be the biggest selling point of this book: it's a book I
can apply to my work _right away_ - I am literally using the things
I've learned at work today. Perfect for the beginner Rubyist, or
anyone who wants some standout techniques for handling text whatever
language they're using.

[^1]: The author gave an interesting example of the power available in command line tools when I saw him speak at [Brighton Ruby], comparing the processing speed of Hadoop against a laptop's UNIX tool chain using small (~2GB) data sets. You can read more about this comparison on [Adam Drake's blog][BigDataCli].

[BigDataCLI]: http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html
[authorName]: https://robm.me.uk/
[bookSite]: https://robm.me.uk/text-processing-with-ruby/
[Brighton Ruby]: http://brightonruby.com/

---
layout: post
title: "<i>Text Processing with Ruby</i> - Review"
date: 2015-10-07 20:39:14
tags:
  - Book Review
  - Ruby
  - Munging
published: true
---

Plain text is at the root of everything we can do as
developers - we read it, we manipulate it, we write it back out as
logs or files or HTML, We write it as the code to do everything else -
we write it as blog posts! It's the universal interface and it's
impossible to avoid. [_Text Processing with Ruby_][bookSite] sets out
to show you how to do it as quickly, and elegantly, as possible.

Dividing into three parts - reading, transforming, and writing - the
book takes you through all of the common tasks you'll have to perform
on text. Where the solution exits in a command line tool, we're shown
how to use it effectively. And where we need something more specialist
we're shown how to use Unix pipes to join tools together, and how to
easily integrate Ruby into that pipeline. Learning this simple
interoperation allows you to leverage forty years worth of shell
commands into your Ruby code (and vice versa).[^1]

Regular expressions are covered in greater depth than I have seen in
other Ruby books, and with a strong emphasis on their real-world
application. These play an essential part when tasks diverge from
those the more sophisticated parsing libraries also demonstrated -
such as Nokogiri for HTML, and Phrasie and Metaphone for natural
language processing - excel at.

On the way we're shown how to use a great number of Ruby's system
variables (the ones starting with `$`) to achieve all of the
above. While some may not like how arcane they can make your code
appear, I found their use in file operations and regular expressions
to make for terse yet readable code - perfect for our quick text
processing scripts.

[_Text Processing with Ruby_][bookSite] is a fun introduction to
handling text; ideal for the beginner Rubyist as it extends knowledge
both of Ruby and text processing, yet sufficiently independent from
the language for me to recommend it to anyone looking to extend their
text munging[^2] skills. The techniques are applicable to all text
anywhere - buy the book and I can almost guarantee[^3] that you'll be
using at least one of them for fun and/or profit within a week of
reading the book.

_I was given a copy of this book to review._

[^1]: The author, [Rob Miller][authorName], gave an interesting example of the power available through using command line tools when I saw him speak at [Brighton Ruby], comparing the processing speed of Hadoop against a laptop's UNIX tool-chain using small (~2GB) data sets. You can read more about this comparison on [Adam Drake's blog][BigDataCli].

[^2]: [Real computing word][munge]. Be glad I didn't describe the system variable stuff as a [kludge]...

[^3]: Almost. Cannot actually guarantee. But that said I'm building a webscraper with Nokogiri at work, and I've been relying heavily on what I learned. Let me know on Twitter how it works out for you.

[BigDataCLI]: http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html
[authorName]: https://robm.me.uk/
[bookSite]: https://robm.me.uk/text-processing-with-ruby/
[Brighton Ruby]: http://brightonruby.com/
[munge]: (https://en.wikipedia.org/wiki/Mung_(computer_term))
[kludge]: (https://en.wikipedia.org/wiki/Kludge)

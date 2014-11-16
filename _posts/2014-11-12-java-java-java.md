---
layout: post
title: "Java"
date: 2014-11-12 12:20:08
tags: [Makers Academy]
categories: [Makers, Java]
published: true
---

Java. Java is the
([second](http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html))
most popular programming language in the world. Java is over twenty years old.
Java is everywhere.

Java is giving me a headache.

Based on a job opportunity I started to try and learn Java last week. Flailing
around for guidance, Enrique told me to install an IDE. [IntelliJ] to be
precise - mainly to get something to manage my dependencies for me.. That's
a whole story in itself, but I hacked around a bit, ran some tutorials, and
eventually I got a Hello World out into the world. Finally
I understood why things in Java could be `public static void`, finally
I understood the syntax. Squint a little and it just looks like JavaScript. Ish.

Step two: testing. [jUnit] turned out to be a testing framework for Java
and should not be confused with [G-Unit].  This I also got going, but not
without reservations. Turns out I don't like IDEs, for some reason they make me
feel seperated from the code I'm writing.  Also I felt ike I didn't have the
time to learn a whole new environment. I use [Vim], and I use it on the command
line, and I like it that way.

So I thought I'd try it from the command line. Not my greatest decision. You've
got two choices about how to manage dependencies and builds from the terminal:
[Maven] and [Gradle]. Maven uses XML to describe the project, one of my
least favourite formats to read (I think I'm faster reading binary), so
I settled rapidly on Gradle, which is actually written in [Groovy], a dynamic
language based on [Java].

But back to the command line. I did manage to manage my projects from there -
and it did give me a feeling of greater control than through the IDE. But it
also revealed what a lot of work the IDE was doing. I feel like I've been
relatively spoiled using [npm] and [Bundler] - just `require` what you
need and it's there - magick. Java - even with [Gradle]'s help - is horrible
to look at. A long mess of `com.something.somethingElse.someMethodHere`, each
individual damn thing being summoned individually. And me with no intuitive idea
of how it all works. I can only imagine what it would be like without
a dependency manager helping out.

I even (by the end) managed to deploy a horrifically simple and untested app to
the [AWS Elastic Beanstalk]. But I never managed to get mocks in [Mockito]
off the ground. And I never really fet like I knew what I was doing.

But after a week of Java, and a week helping out with [Node] at Makers,
getting my hands back on Ruby was lke coming home. How do I feel after
experiencing my first [strongly typed] [compiled] programming language?
Overall I'm OK. I learned a lot about [design patterns] and the [SOLID]
principles - chiefly about where they're from. A lot of the language about
interfaces makes a lot more sense when you're building an interface seperately
and implementing it in one of perhaps many classes. And forcing me to declare
the type of returned object for each method (if any), and the type of each
argument, and especially whether they're public or private, made me think harder
about methods in general.

Travel broadens the mind!

[IntelliJ]: https://www.jetbrains.com/idea/
[jUnit]: http://junit.org/
[G-Unit]: http://en.wikipedia.org/wiki/G-Unit
[Vim]: http://www.vim.org/
[Maven]: http://maven.apache.org/
[Gradle]: http://www.gradle.org/
[npm]: https://www.npmjs.org/
[Bundler]: http://bundler.io/
[AWS Elastic Beanstalk]: http://aws.amazon.com/elasticbeanstalk/
[Mockito]: https://code.google.com/p/mockito/
[Node]: http://nodejs.org/
[strongly typed]: http://en.wikipedia.org/wiki/Strong_and_weak_typing
[compiled]: http://en.wikipedia.org/wiki/Compiled_language
[desigk patterns]: http://en.wikipedia.org/wiki/Software_design_pattern
[SOLID]: http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)

---
layout: post
title: "The C Programming Language Part One: hello, world"
date: 2016-05-26 22:35:20
tags:
    - C
    - Languages
    - Learning
published: false
---

I've started to learn C. There's a number of reasons for this. First, it was the
'proper' programming language when I was a kid. Second, I've been learning quite
a bit of Go recently, and just about every other page on the excellent Go Blog
has a sentence that starts with "In C...".

Third, I've started a course on [Data Structures and Algorithms] on [Coursera],
inspired by the ever-inspirational [Denise Yu]. The course only accepts
submissions in four languages: Python, Java, C++ and C.[^1] Going through that
list my mind went "Basically Ruby with _bleaugh_ indentation, _bleaugh_ Java
_bleaugh_, sounds really hard, sounds hard." So I went with 'sounds hard' - and
I'm really glad I did.

I thought I'd try and capture my process of learning C from a Ruby/JavaScript
background as it might be useful to others in a similar position - people with
no CS background but who do know how to program. I'll be approaching this in
a series of posts, most of which will be following [a presentation I gave on
C][presentation].[^2]

## Background

C was invented by Dennis Richie at Bell labs in the 1970s in order to wrte
UNIX.[^3] He needed a language that provided sufficient abstraction to be able
to write a program quickly and efficiently, while at the same time being able to
communicate directly with the computer's memory addresses to allow a programmer
to perform low level optimizations. It has been a remarkably popular language,
being used to write other languages (parts of Ruby are written in C,  NodeJS
uses C to make certain operations faster), and heavily influencing most modern
programming languages (Java, Ruby, JavaScript, and most obviously, Go).

## `hello, world`

Another of the ways C has influenced programming is through the book [_The
C Programming Language][cbook] by Kernighan and Richie. The author's intials
gave their name to a [code format style][K&R], along with giving us the _de
facto_ industry standard for the first program you write in a language: "hello,
world".

And it's pretty simple and instructive in C:

```clang
#include <stdio.h>

int main() {
    printf("hello, world\n");
}
```

Line 1: Include a file called `stdio.h`. It includes information about the
functions in the C standard library that deal with I/O - input/output. In this
case printing to the terminal.

Line 3: All C programs start with a function called `main` - this is the
function that gets executed when the program is, well, executed. The arguments
(of which we're using none at all) are in the parentheses. The body of the
function is in the curly braces. So far so JavaScript. For people who have never
seen a typed language the `int` is a little surprising. All it's telling us (and
C) is that the return value for this function is an integer. We'll talk about
types later, but for now the int is almost working like `def` in Ruby or even
`function` in JavaScript.

Line 4: The meat of the program. Here we're calling a function called `printf`
which has already been written for us as a part of the C standard library - this
is why we did that `#include` at the beginning. We're calling it with a single
argument, a string literal inside double quotes, that just says "hello, world"
with a newline character (`\n)` at the end.

At the end of the line we put a semi-colon to tell C that the line has finished.

## Compiling and running

If you put all of that into a file called `hello-world.c`, save it, head to the
terminal and type[^4]

```shell
gcc hello-world.c
```

Then if you `ls` the same directory you should see a new file called`a.out`.[^4]
If you then run this with `./a.out`, you'll see `hello, world`. Mission
accomplished.

`gcc` is the Gnu Compiler Collection[^6], which will compile your C program into
an executable that your computer can run. All this means is that instead of
translating each line of your program into something your computer can
understand as you run it, as with something like Ruby or JavaScript, we're
translating the whole program in one go before we run it.

`a.out` isn't that informative, so in order to get a better filename we can pass
a flag to GCC:

```shell
gcc hello-world.c -o hello-word
```

Which outputs to the file `hello-world`, which we can now run with
`./hello-world`

Success, we're now all C programmers!

### Why `main` returns an `int`

If you've run programs on the command line before you may be aware that you get
exit codes with each program that runs. You may have even been (un)lucky enough
to see something on the lines of `Error: non-zero exit code`. On an POSIX
system, a process returns a number to the process that called it to let it know
how it went - this is called the exit code. `0` is the good one, every other
number is some shade of 'gone wrong'.

The default return value for main, if we don't explicitly return a value, is `0`.
We can change this behaviour in our `hello-world` by returning an explicit
value using the keyword `return` - very Ruby, so JavaScript.

```clang
#include <stdio.h>

int main() {
    printf("hello, world\n");
    return 1;
}
```

(don't forget the semicolon!)

Experiment with different return values. Remember to recompile your program each
time you do. You may be able to see the returned value in your terminal's
prompt. Otherwise you can echo out the last commands exit status with the
command `echo $?`.

[^1]: You can now do the same course with a more diverse set of languages.
[^2]: This was given at a Makers Academy alumni event. To view the speakers notes tap `n`.
[^3]: A longer discussion of the origins of C was written by Richie and is available here: https://www.bell-labs.com/usr/dmr/www/chist.pdf
[^4]: This assumes you have gcc installed, which is likely if you've been developing on your computer for a while.
[^5]: You want to know _why_ it's `a.out`? Read Richie's C History - link above.
[^6]: Bet it used to be called the Gnu C Compiler - acronyms are so wonderfully flexible...

[presentation]: http://blog.gypsydave5.com/the-c-programming-language-presentation/
[cbook]: https://en.wikipedia.org/wiki/The_C_Programming_Language
[K&R]: https://en.wikipedia.org/wiki/Indent_Style#K.26R_style


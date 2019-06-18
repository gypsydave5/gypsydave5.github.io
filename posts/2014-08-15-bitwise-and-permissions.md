---
layout: post
title: "Bitwise and Permission"
date: 2014-08-16 20:32:45
tags:
    - Makers Academy
    - Ruby
    - TDD
    - Bitwise
published: true
---

So I thought I'd try and write about what happened last day of the first week at
[Makers][MA], as mentioned in [my last post], about the failing RSpec test for
the Unix task. Just because I learned a lot about both permissions on a Unix
like system, about bitwise operators in Ruby, about how RSpec works, and how
(not) to fix things.

So... the test checking file permissions in a directory by running the following
RSpec test.

```ruby
  it "Should only allow the owner to change into my/private/files" do
    folder = "my/private/files"
    permissions = File.stat(folder).mode
    expect(permissions & 0000100).to be_true
    expect(permissions & 0000010).to eq(0)
    expect(permissions & 0000001).to eq(0)
  end
```

When we first ran it, it failed on the first expectation above - even though we
knew that the file had the right permissions. So what was going on - both in
terms of how it was meant to work, and why it wasn't working?

## Permissions

Let's start with that first expectation.

```ruby
expect(permissions & 0000100).to be_true
```

`permissions` is a variable representing the result of `File.stat(folder).mode`,
where `folder` is the directory being checked. The `mode` method [returns the
permissions-bits of the Unix `stat` command][filemode] - which you can take
a look at in detail with a quick `man stat -a` (as it's `stat(2)` you're looking
at.

What does all this mean? It means that we're getting back an integer which
represents the current permissions on the file. And how does an integer
represent permissions? If you've been using `chmod` to change permission with
commands like `chmod go-w filename` (remove write from group and others), well
- you've been missing a trick and a whole lot of fun.

The fun way to set permission is using the *absolute mode*, which sets the
permissions absolutely every time you use it (rather than relatively removing or
adding them from the current state - see `man chmod` for more). There are three
settings (read, write and execute) for each of the three permissions groups
(user, group, other) on a file. Each of those permissions sets is represented
by a single octal digit (from 1 to 7), and the settings are literally added to
each one - the setting for read is 4, write is 2 and execute is 1.

Any combination of these numbers will produce a unique number - read + write
= 6, write + execute = 3, just read = 4. And you can combine them into
a three-digit octal number which represents the file permissions for any given
file, where the first digit is user, the second is group and the third is other.

In practice: `chmod 777` gives permissions for everything. `chmod 644` gives
read/write to user, and just read to group and other. `755` is
read/write/execute for user, and just read/execute for the group and other.

## The science "bit"
Notice how none of the octal numbers ever 'carry' over to the next one when
they're added together? This is a piece of computer science wizzardry - because
they're in octal, I can look at them as both an actual integer or as a series of
switches (or maybe dials), setting permissions for each permissions group up and
down. Thing is, for your computer, these two ways of looking at it *are exactly
the same*.

`777` in decimal notation is `511` (do the maths if you like), but also has
a binary representation of... `111111111`. Hey, look - all the 1s! It's like all
the switches are turned on - and they really are!. This is because octal digits
map really neatly to binary digits - they're a three-digit long collection of
binary digits. 'Binary digit' is a bit of a mouthful (pun intended), so let's
use the shorthand word - bit. Each set of three bits represents one of the
permission statuses for a particular permissions set. So the first three 1s
above are the permissions for the user, and in particular the first one is the
read, second write and the third the execute - all set to 1 or 'on'.

(Experiment in a Ruby repl like pry or irb - you can switch between binary,
octal and decimal really quickly in Ruby. Any integer you type in with a leading
`0` (say `0777`) will automatically be translated as an octal (`0777` will
return `511` - the decimal representation). And you can flip to a binary
representation with `to_s(2)` - the `(2)` setting the base of the conversion, so
that `0777.to_s(2)` will return `"111111111"`. Try some other numbers!)

So when `mode` returns an integer, it's the integer that represents the current
permissions on that file - a file with read, write and exeute permissions for
all the sets would give you the number `511` (which is the same as `777` and
`111111111`).

## Bitwise
Now we get to the fun stuff - `permissions & 0000100`. What's the `&` doing? And
those leading 0s? As mentioned above, the leading zeroes are just Ruby's way of
saying that this number is in octal. So (repls open) `0000100` just becomes
`64`. But the thing doing the work here is `&` - not our friendly Boolean `&&`,
but a differnent beast - this is the [**bitwise AND**][bw&].

Bitwise operators, of which `&` is an example, really tear the lid off the
computer and get a little bit closer to the bare metal. Computers aren't made of
objects, or lines of code, strings and integers. They're made of 0s and 1s. And
bitwise operators work on 0s and 1s - or, specifically, binary numbers.

Let's take a pair of binary numbers, say `111` and `100` (known to you and me as
7 and 4). Bitwise AND compares the bit in each position, and asks the question
"are you both `1`?" If they are, you get a `1`, otherwise it's a `0`. So `111
& 100` will return `100` as the third bit (counting from the right) is the only
one that matches in each number

(Think of it just like a regular logical AND - but `1` is `true` and `0` is
`false` - running on each bit position.)

We now have enough knowledge to look at the test again

## Back to the test
To recap, the test looks like this:

````ruby
  it "Should only allow the owner to change into my/private/files" do
    folder = "my/private/files"
    permissions = File.stat(folder).mode
    expect(permissions & 0000100).to be_true
    expect(permissions & 0000010).to eq(0)
    expect(permissions & 0000001).to eq(0)
  end
```

The key line being:

```ruby
expect(permissions & 0000100).to be_true
```

Now let's pretend that the directory currently has permissions of `700` - read,
write and execute ('execute' is 'open' for a folder -- allowing you to `cd` into
it). We run `mode` on it and get the permissions integer back - in octal, that's
`700` again. We then run a bitwise AND - the `&` against it using the octal
number `100` (all those `0`s at the beginning are just saying 'hey! I'm octal!'
to Ruby).

Converting octal to binary, `700` is `111000000`, and `100` is `1000000` (Don't
trust me? Fire up a repl!). Maybe think of `1000000` as `001000000` for the next
bit. Comparing the two binary numbers, the only place they match is at the
seventh bit - and so we get `1000000` as the returned value. Which, in octal is
`100` and in decimal is `64`.

The neat thing about this is that it will return `64` for any permission set
that includes user executable permission on a file - `700`, `500`, `177`, `355`,
`777` -- they *all* work. Say we've got `355` - in binary that's `011101101`.
`&`ing it with `001000000` again will give us... `001000000` again - hey, it's
`64`! Try it with as many numbers as you like.

The other two tests are to check whether the Group or Other sets also have
execute permission -- that's `010` becoming `000001000` and `001` to
`000000001`, bitwised against the permissions making sure they *don't* have that
bit set. They come out as `0` -- no matches!

And so that's how it all hangs together. But why didn't it work? Simply put
everyone on the course had just installed the latest version of RSpec, and
`be_true` is not in the latest version's syntax. So all we needed to do was
change `be_true` over to `eq(64)` and it would've been fixed.

Of course, that's not what we *actually* did. What we did was hack around until
it worked, and even then we ended up with `is_not eq(0)` instead of the neater
(and more correct) answer of `eq(64)`. It was only when thinking about it over
the weekend that I really got a handle on what was going on

[MA]: http://www.makersacademy.com/
[my last post]: /posts/2014/8/9/makers:-day-5/
[filemode]: http://www.ruby-doc.org/core-2.1.2/File/Stat.html#method-i-mode
[bw&]: http://en.wikipedia.org/wiki/Bitwise_operation#AND

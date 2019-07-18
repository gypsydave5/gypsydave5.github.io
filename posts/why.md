---
title: Why learn about... bits, bytes and binary
description: enough about bits to make you a bit dangerous
published: false
date: 2019-07-12 22:52:55
tages:
  - computerscience
---

One of the goals of good computer programming is to provide the
user of our software with a good _abstraction_; we don't want our
web browsers to be forcing us to think about HTTP requests, we want
to click links and see pages. We don't want to know how an object
is created in memory in JavaScript, we just want to use it to display
cat videos in our browser.

But often we're exposed to some of the hideous truths buried beneath
our comfortable abstractions. Perhaps because of an error in our
code. Or because we're having to work with our computers at a more
fundamental level. Or it's because some clever sod decided that all
the user entitlements would be modelled using a bit mask.[^1]

Anyway, this is an article about bits, bytes and binary. It's also
about octal and hexadecimal, but that doesn't make for as catchy a
title.

## Who is this for?

This is for any software developer, but will probably be of most use to those
who (like me) do not have a computer science background. It would be helpful if
they have some experience of using a Unix-like system (OSX, Linux), and of
writing colours in CSS. But this is not necessary.

The focus is on understanding the meaning of a bit and a byte, and on reading
and understanding binary, octal and hexidecimal numbers. The skills developed
are meant to be practical; they are applicable to a wide range of subjects that
are encountered by a software developer:

- file permissions
- IP addresses and networking
- Reading stack traces
- CSS colours

We will not examine less applicatble topics like binary arithmetic.

Oh and it might be fun in a geeky kinda way.

## A Bit

What's a bit? It's fundamentally a pun - a contraction of the words
_binary digit_. A bit is a digit in _binary_. Let's get back to
bits in a minute - what's binary?

## Binary

You can count - I'm assuming you can count. In the decimal counting
system using Arab numerals - the counting system that's been popular
in Western Europe (and then the rest of the world) since the Renaissance,[^2] there
are ten digits:

	0 1 2 3 4 5 6 7 8 9

When we represent _any_ number in decimal, we use these numerals.
But we don't just write them in any order; the position of each
numeral tell us how many of a power of ten goes in to make the
number.

For instance

	1337

Is a number made up of

- one lot of the third power of ten - 'ten to the three' - a thousand
- three lots of the second power of ten - 'ten to the two' - three hundreds
- three lots of the first power of ten - 'ten to the one'- three tens
- and seven lots of the zeroth power of ten - 'ten to the zero' -  seven ones

It might seem a bit odd to think of the final digit representing `n`
lots of the zeroth power of ten, but I hope you can see how it fits in
with the rest of the digits. This is probably how you've been counting
for most of your life, but probably without thinking of each of the
digits as representing a count of a power of ten.

But why represent numbers using ten digits?[^3] Why not, say, two?


	0 1

And so we have _binary_, a number system based on using two digits to
represent every number. Each digit in a binary number represents a
_power of two_, just as every digit in a decimal number represented a
_power of ten_.


So

	1101

Means

- one lot of the third power of two (1 * 2^3 = 1 * 8 = 8)
- one lotof the second power of two (1 * 2^2 = 1 * 4 = 4)
- zero lots of thefirst power of two (0 * 2^1 = 0 * 2 = 0)
- and one lot of the zeroth power of two (1 * 2^0 = 1 * 1 = 1)

So the number represented by `1101` is 8 + 4 + 1 -- it's 13

## Back to the Bits

So now we have an answer to the question 'what is a bit?' - it's a
binary digit, or in other words it's a `0` or a `1`. Actually, why is
it either of those symbols? We could choose anything - we could use 🙂
and 🙃, or 👍 and 👎, or _anything_ we like. Remember, it's just a
_representation_ of a number - it's not actually a number itself.[^4]

Now, inside your computer, at any one time, everything that's going on
is kept as a series of high- and low-voltage ???registers??? in memory
and (solid state) disk. We use these many millions of ???boxes with
voltages in??? to represent _everything_ that we ever do on a
computer.


And when we represent these voltages, we do so as binary digits - as
bits. We say the low-voltage ???box??? is `0` and the high voltage
???box??? is `1`. This, if you like, is the original abstraction of
all computing - the moment it stops being elecronic engineering and
becomes something else - we can stop thinking about the hardware and
start thinking about... bits.


## Practical one: integers

It probably won't surprise you that one of the easiest things to
encode into bits are integers - whole numbers. We've pretty much done
it above. So we know that the number


	1101

is thirteen.

But how do we write _negative_ integers? We can't just write

	-1101

because all we have to play with is `0`s and `1`s? The obvious answer
is to just use a zero or one to mark a number as being positive or
negative. So we could have `0` means positive, and `1` means negative,
giving us


	01101

for thirteen and

	11101

for minus thirteen.[^5]

But it doesn't take a genius to see a problem here: how can we tell
the difference between `11101` as "minus thirteen" and `11101` as
"twenty-nine" - which is what we'd get if we counted that first `1` as
one lot of two to the power of four (sixteen) - ?

This is an example of a bigger problem: when do we stop reading the
bits? What tells us - or the computer - that this bit is the end of a
number (or a character, or a string, or a an object) and the next one
is the beginning of another?


## Bytes

This is where _bytes_ come in. A byte is a collection of bits - yes,
this is definitely a pun about biting things. In every computer you
will come across a byte is made up of _eight_ bits:[^6]


	10101010

or

	11111111

A byte gives us a way of knowing when to stop - think of it like a
word in a natural language; if all the letters were mushed together
without spaces we'd find it hard to know when one word stopped and the
next one began.[^7]

So now we can store unsigned integers (without a plus or a minus sign)
in a byte. Hooray! We can successfully count all the way up to...
two-hundred and fifty-five. Well, that sucks, as I'm pretty sure I can
think of bigger numbers. This is why we can use more than one byte
when we're representing a number.

If we use two bytes

	11111111 11111111

We can get up to sixty-five thousand five hundred and thirty-five.
Don't trust me - go and count for yourself. I'll wait.


Throw another two bytes at the problem

	11111111 11111111 11111111 11111111

And we can reach the heady heights of... 4294967295. Which is a very
big number.


I'll let you in to a trick: the biggest number that you can represent
using binary is 2^n -1, where n is the number of digits in your
number. So I calculated the above number by working out 2^16 - 1.
Don't worry: I didn't use my fingers...[^8]

Great, so now we can calculate big numbers, and we know when to stop
reading the numbers - we just need to know how many bytes they're made
of. But what about those pesky negative integers? How do we know
whether

	11111111

is two-hundred and fifty-five or minus one-hundred and twenty-seven?

This is why computers - and computer programming languages - have
_types_. Yes, there are other reasons to have types - please, Haskell
programmers, don't have a fit. But this is the most general case A
type will tell you not only how many bytes a 'thing' takes up in
memory, but also what sort of a thing it is. So if you know that
_those_ four bytes over there are a signed integer:

	10000000 00000000 00000000 00000100

Then you know that it's the number -4. But if it's an _unsigned_
integer then it's the number 2147483652. And if it's a floating point
number, or a string, or perhaps an object...

A lot of programming languages do you, me and everyone else the
significant service of hiding all of this from our eyes - Ruby will
automatically turn one size of integer into another size of integer
when it gets too big to be stored in a certain number of bytes. Other
languages side step the issue by having only _one_ type for all
numbers; JavaScript uses a 64 bit double precision float for every
number.[^9]

Some programming languages - usually lower level ones - will tell
you _exactly_ how much space in memory one of your values is taking
up, which can give a programmer more control over the amount of memory the
program is using. In Rust, for instance, you can have a `uint32` - an unsigned,
thirty-two bit integer. That information, combined with what we've learned
above, gives us enough information to know

- that the value takes up four bytes (32 / 8 = 4)
- that the maximum value of a `uint32` is 4294967295 (2 ^ 32 - 1)

Sometimes this is useful, sometimes it's not. But it's always good to know.

## Not just binary 1: CSS and Hexadecimal

Binary 'thinking' leaks out of lower level programs and out into the way we
write things that, on the face of it, really shouldn't be related. For instance,
one of the first things I ever wrote as a program probably looked something like

	body {
	  background-color: #FFFFFF;
	}

Yes, CSS! What the hell were all the Fs about? Why on earth was that _white_?
I remember experimenting with different values to see what worked and what
didn't - the joy of programming!

What's weird is that one of the first things we do in simple web programming
turns out to be a great example of binary numbers making a surprise appearance.
You see, `FFFFFF` is actually a twenty-four bit number, represented in
_hexadecimal_ notation.

Hexadecimal is just counting in base sixteen ('hexa' like six, as in hexagon,
'decimal' like ten - it's Greek...). Now when we used binary we got rid of a lot
of digits - everything that wasn't `1` or `0`. But for base sixeteen we need
another six digits to make the total up to sixteen. So we just start counting
using letters! `A` is ten, `B` is eleven and so on up to `F` being fifteen.

So we can count up to twenty like this (starting at zero, naturally):

	0
	1
	2
	3
	4
	5
	6
	7
	8
	9
	A
	B
	C
	D
	E
	F
	10
	11
	12
	13
	14

Big woop. So what? Why on earth would you use a base of sixteen when you've got
decimal - everybody's favourite and universally popular?

Hexadecimal is useful because it _plays nicely with binary_. Sounds weird,
right? Let me explain: because sixteen is the fourth power of two ('two to the
four'), each hexadecimal digit can represent _four_ binary digits - with no
carry over.

When we represent a binary number in decimal we can never be sure how many
binary digits will be used for one decimal digit.

	1001

becomes

	9

only one digit

	1010

becomes

	10

two digits!

But because the first four bits in a binary number are for all numbers from zero
to fifteen, they map perfectly on to a single hexadecimal digit.[^10]

For instance

            |                    |        |        |        |        |        |        |        |        |        |
-           |             :-:    | :-:    | :-:    | :-:    | :-:    | :-:    | :-:    | :-:    | :-:    | :-:    | :-:
binary      |             `1101` | `1110` | `1010` | `1101` | `1011` | `1110` | `1110` | `1111` | `0001` | `0000` | `0001`
decimal     |             13     | 14     | 10     | 13     | 11     | 14     | 14     | 15     | 1      | 0      | 1
hexadecimal |             D      | E      | A      | D      | B      | E      | E      | F      | 1      | 0      | 1

This demonstrates another useful aspect of hexadecimal: writing fun messages.

So hexadecimal is really good at representing known 'blocks' of binary
information - four bits to each hexadecimal digit.

And if there are two digits, then there are eight bits... it's a byte! So what
we're seeing here is a three byte - twenty-four bit - number, written out in
hexadecimal notation.

But... why do this for a _colour_?

Each of those bytes represents a component of the colour being
described - red, green and blue. So by writin it out in hexadecimal
you get some visual indication of when each element begins and ends
- it's two hex digits - and you also know that the length of the
number will always be six digits. And it's one hell of a lot easier
to read than it would be in decimal (0 to 16777215 anyone...?).

## Not just binary 2: File Permissions and Octal

The other number system that comes up with some regularity (although less than
hexidecimal) is _octal_, which uses eight as the base. Again, this base is no
accident; a single octal digit can represent _three_ bits:

                            |          |          |          |
                    -       | :-:      | :-:      | :-:      | :-:
                    binary  | `101101` | `110110` | `010010` | `111111`
                    decimal | 45       | 54       | 18       | 63
                    octal   | 55       | 66       | 22       | 77

A single octal digit can represent numbers from 0 to 7, and two of them can
represent numbers from 0 to 63.

One of the strangest, but also most interesting, uses of octal is in
representing file permissions in Unix. If you're in front of a Linux or Mac
computer right now, open a terminal session and type `ls -l`. You should see
something like this:

```
total 80
-rw-r--r--   1 davidwic  1482096370    897  9 Jun 22:06 README.md
-rw-r--r--   1 davidwic  1482096370    127 20 Jun 08:45 config.toml
drwxr-xr-x  27 davidwic  1482096370    864  9 Jun 22:06 drafts
drwxr-xr-x   8 davidwic  1482096370    256 19 Jun 01:42 extras
drwxr-xr-x   6 davidwic  1482096370    192  5 Jun 21:24 images
drwxr-xr-x   3 davidwic  1482096370     96  9 Jun 22:06 pages
drwxr-xr-x  66 davidwic  1482096370   2112 13 Jul 00:16 posts
-rwxr-xr-x   1 davidwic  1482096370    138 19 Jun 00:26 publish-on-s3.sh
-rwxr-xr-x   1 davidwic  1482096370    334  9 Jun 22:12 publish.sh
-rw-r--r--   1 davidwic  1482096370    259 17 Jun 21:45 serve.go
drwxr-xr-x  12 davidwic  1482096370    384 19 Jun 22:48 site
drwxr-xr-x   3 davidwic  1482096370     96 19 Jun 00:24 templates
-rw-r--r--@  1 davidwic  1482096370  18110 30 Jun 23:33 test.html
```

The column on the right represents the _file permissions_ for each file. The
first character shows whether its a directory (a `d`), and the other nine show
`r`ead, `w`rite and e`x`ecute permissions for the owner, the owner's group and
everyone else.

So if a directory could be read, written and executed by the owner it
would say

	drwx------

And if a file could be read by everyone

	-r--r--r--

Fun times.

But we don't really need the letters - the position of the flags give us all the
information we need. If we say that `0` represents disabled, and `1` represents
enabled, and ignoring the directory flag, we could write the file permission above as

	100100100

Oh hey look - a binary number!

Now look at the repeating pattern - it goes Read, Write and Execute three times.
We could break this up into groups of three bits:

	100 100 100

But after our brush with hexidecimal we know that each of those groups of three
binary numerals can be written as a single octal numeral:

	444

For that one, but for the directory that can only be used by the owner:

	700

These magic octal file permission numbers come up _disturbingly_ often - more
often than you'd think was necessary in the twenty first century. For instance,
exciting modern programming language Go [needed to model file
permissions](https://golang.org/pkg/os/#FileMode), it did so by using as 32 bit
_number_ where the nine 'least significant bits' (i.e.  the end of the number)
represented `rwxrwxrwx` permissions as above. The same occurs in Python, and
[NodeJS](https://nodejs.org/api/fs.html#fs_file_modes).

Treating numbers as flags has some exciting - or gnarly - side effects. For
instance, if you wanted to make creating permissions a bit more readable you
could do something like

```
owner_read = 0400
owner_write = 0200
group_read = 0040
other_read = 0004

permission = owner_read + owner_write + group_read + other_read // => 0644
```

Which reads better - but we don't want to do this:

```
permission = other_read + other_read + other_read // => 0020 - group write!
```

But there _is_ a way around this - we can use a special set of operators that
work on numbers _at the bit_ level, treating each bit as a boolean flag.

## Bitwise Operations

Look, I'm not sure I should be telling you this - it's pretty low level and
nasty. But we've come this far and we can't turn back now.

So you're used to booleans when you're programming - things like `True` and
`False` - and the operations that we can perform on them - things like _and_ and
_or_. They probably look something like this in your language (this is in Ruby):

```ruby
true && true == true
false && true == false
false || true == true
false || false == false
```

`&&` is the boolean 'and' operator, and `||` is the boolean 'or' operator. There
are others (like 'not'), but let's focus on these two.

What if we treated the binary digit `0` as false, and the binary digit `1`
as true?[^11] We could do something very similar:

```
1 & 1 == 1
1 & 0 == 0
1 | 0 == 1
0 | 0 == 0
```

Most programming languages will have these operators - `&` is 'bitwise and', and
`|` is 'bitwise or'. They work by looking at numbers as a series of bits and
comparing the bits at the equivalent positions. They then treat the two bits
they're comparing like booleans above, and they use the resulting bit to
construct a new number - the result. It's probably easier to see than to
describe - let's stick another two digits on to the examples above:

```
001 & 101 == 001 // only the last bit is set in both numbers
101 & 111 == 101 // only the first and last bits are set in both numbers
100 | 010 == 110 // the first or the second bits are set in both numbers
001 | 000 == 001 // are you getting the hang of it now?
```

By using the `|` operator when constructing file permissions as above, we can
avoid the bits 'overflowing' into the next digit and changing the permission
- we can think of `|` as having the meaning 'apply permission' in this
  context.[^11]

```
permission =  004 | 004 | 004 // => 004 - no matter how many times you 'apply' it!
```

and `&` makes a funky way to test for which file permissions have been set.

```
other_execute = 0001
if current_file.permissions & other_execute != other_execute {
  // don't have execute permission!
}
```

This works because, if the last bit isn't set in the `current_file.permissions`,
the result of `&`ing it with `0001` will _always_ be `0`

```
  0000 & 0001 // => 0000
  0006 & 0001 // => 0000
  0742 & 0001 // => 0000
  0001 & 0001 // => 0001
  0777 & 0001 // => 0001
```

There are other bitwise operators - really, really funky ones that produce an
'exclusive or', shift bits to the left and right, and invert all the bits in
a number ('bitwise not'). Take a look at them if you have time.[^12]

## Conclusion

Bits are useful as they're pretty much as low level as you _can_ go when
programming. When you know that an integer is stored in 64 bits, it will give
you a good idea of just how large that number can be.

Bytes are probably the smallest abstraction that you'll work with on a day to
day basis. You'll usually see them when dealing with raw information - byte
arrays and byte streams. They form the building block of larger data
structures, like strings.

Number systems like hexadecimal and octal are a common way to show data of
a number of bytes conveniently. They let you reason about the size of the data
(the number of bits needed).

## Appendix: using `dc` to handle conversion

Working with binary, octal and hexadecimal - and converting between
them all and decimal - can be a pain in backside. To avoid trying
to do all the maths on your fingers (and toes), I recommend using
some sort of calculator. Vavious tools are available online to do
this for you, but a tool is available at your fingertips if you're
on a Unix-like system: `dc`, the desk calculator.

We can tell `dc` to use different bases for input and output by using
the `i` and `o` commands - so


	2 i 16 o

will tell `dc` to use binary as its input and to output numbers in
hexadecimal. We can then input a binary number and then use `p` to
print it out as hexadecimal.

	16 o 2 i 1111 p

will return

	f

You can run this calculation through `dc` either by running it
interactively (start `dc` and then type in the expression), or by
sending the expression in with a flag

	dc -e '16 o 2 i 1111 p'

or piping it through on standard input

	echo '16 o 2 i 1111 p' | dc

It's a quick way to do the conversion, although it does takes some
practice to remember how to use `dc`.

[^1]: I've worked at that company - the clever sod left years ago, but he is still 'fondly' remembered...

[^2]: As opposed to Roman numerals, which are only really popular now on clocks and copyright notices.

[^3]: There are _great_ reasons to do this, not least because we've got ten fingers.

[^4]: Not wanting to get too philosophical about this, but it's interesting how quickly we can get to some vary rarified ideas when we talk about computers - questions like "what _is_ a number?" don't come up very often in everyday conversation. This should be a hint to us that we're either doing something very clever and difficult, or something completely pointless.

[^5]: This is _not_ how it works in real computers - I'm sorry to mislead you. If you're _really_ interested in this stuff - and I mean really interested, as I think I'm pretty interested but even I find this a bit a bit tedious - you should read some articles on [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement). The reason you use two's complement rather than another way of encoding numbers is to permit the performance of binary arithmetic on the bits in identical ways whether the number is positive or negative. But as I'm not covering that here then I'm happy to gloss over it and push on with the more useful stuff.

[^6]: There is no _necessity_ behind having eight bits in a byte, and in fact a lot of early computer systems used six or seven bits as their _byte size_. But eight is standard these days.

[^7]: Hard... but not impossible. Ancient Greek was written in ALL CAPITALS WITHTHESPACESREMOVED. And you think it's hardReadingThingsInCamelCase...

[^8]: I used `dc`, the standard Unix desk calculator. More about it later.

[^9]: Which leads to a lot of craziness.

[^10]: We actually do something very similar everyday with decimal numbers: it is customary to group the digits of large numbers into threes, making them easier to read - i.e. `1 345 383 398`.

[^11]: This should not be too much of a leap for those of you familiar with JavaScript's definition of truth...

[^12]: I must emphasise that this is not a pattern that should be emulated - it works nicely for file permissions as it's small (and so memory efficient) and will never need more than the nine bits assigned. If you were to repeat this pattern for, say, different departments in an organization, you'd severely impair the readability of the code and limit the number of departments to the reserved bits.

[^12]: 'Bit shifting' makes for an efficient, if obscure, way of multiplying and dividing by two while rounding down.

---
layout: post
title: "Downloading a list of URLs"
date: 2016-02-04 21:43:25
tags:
  - Bash
  - curl
  - xargs
  - gnu
  - parallel
published: true
---

Say you've got a list of URLs - a long list of URLs - each of which points to
a file. Perhaps they're a set of logs, or backups, or something similar. The
file looks like this:

    http:/www.somedomain.com/my/file/number-one.txt
    http:/www.somedomain.com/my/file/number-two.txt
    http:/www.somedomain.com/my/file/number-three.txt
    ...
    http:/www.somedomain.com/my/file/number-five-hundred-and-x-ity-x.txt

Now what we don't want to do is copy and paste each of those file names into
a browser to download the file. That would suck. What would be ideal is to drop
the file into a magic box, and that magic box just work through the list,
downloading the files until they're all done.

Happily every *nix command line comes with its very own tooling to build a magic
box like this.

### `wget`

My first instinct would be to use [wget], which is certainly the friendliest way
I've seen to download files on the command line. Taking a short read of the
manual with `man wget` we can see the following:

    -i file
       --input-file=file
           Read URLs from a local or external file.  If - is specified as file,
           URLs are read from the standard input.  (Use ./- to read from a file
           literally named -.)

So the job is incredibly simple - we just type:

    $ wget -i file-with-list-of-urls.txt

and we just let wget do its magic.

### `url` and `xargs`

That was too easy - I love `wget` and usually wind up installing it on any
system I use for longer than 30 seconds. But sometimes it's unavailable - maybe
there's no package manager, or you have no rights to install packages because
you're remoting in to a tiny machine running a very skinny Linux distro. In
these cases we're going to have to rely on `wget`'s older, less forgiving but far
more flexible sibling [curl].

The quick and generic `curl` command to download a URL is:

    $ curl http://www.file.com/file.txt -LO

`curl` has a wealth of uses and options - we're barely scraping the surface with
what we're doing here. Take a look at the full `man` page and you'll see what
I mean.

But for this command: the `-L` flag tells curl to follow redirects - if it
wasn't there we'd get the `30x` response saved rather than the file at the
location we're being redirected to. The `-O` flag means that curl uses the name
of the remote file to name the file it's saved as, saving us the bother of
naming the output.

In order to pass each of the URLs into curl one after another we get to use
[xargs], which is a wonderful piece of witchcraft you can use to pass lines
from `STDIN` in as arguments to another command.

The full command looks like this:

    $ cat file-with-list-of-urls.txt | xargs -n 1 curl -LO

`cat` we should be comfortable with, it sends each line of a file out to `STDIN`
one at a time. Here we're piping out each line to `xargs`.

`-n 1` tells `xargs` that it should be expecting one and only one argument for
each execution from `STDIN` - in other words each of the URLs will be used as
a sindle extra argument to `curl`. If we didn't do this, how would `xargs` know
how many additional arguments `curl` wanted? It could just use every URL as an
extra argument to a single `curl` execution. Which would suck.

So we take in an extra argument from `STDIN`, here being piped in by `cat`, and
we apply it to the end of `curl -LO`. `xargs` will now run `curl` for each of
the URLs.

### Optimization

Five hundred or so files is going to take a long time to download. Try passing
`-P 24` to `xargs`, which tells it to run the multiple curls as 24 parallel
processes. That'll whip along nicely (if your machine can take it).

Another nice feature would be the ability to output to a filename that was not
the same as the remote file - the path could be really annoying and long. Using
`xargs` we'd be somewhat limited, and would have to change the input file to
include not only the new file name but also an extra argument to curl, `-o`,
which gives the output file name.

The URL file list would look like this:

```
    http:/www.somedomain.com/my/file/number-one.txt
    -o
    number-one.txt
    http:/www.somedomain.com/my/file/number-two.txt
    -o
    number-two.txt
```

and the command would be

    $ cat file-with-list-of-urls.txt | xargs -n 3 curl -L

But the same can be achieved without changing the original file list using [GNU
parallel], which is a distinct improvement (apart from the three extra
characters).

    $ cat file-with-list-of-urls.txt | parallel curl -L {} -o {/}

which passes the original URL to the `{}` and then removes the path from it with
the `{/}`. There's plenty more you can do with `parallels` - take a look at [the
tutorial][parallels-tutorial].

Finally, it would be remiss of me not to mention that all the uses of `cat`
above are entirely superfluous - the same could have been achieved with:

    $ <file-with-list-of-urls.txt parallel curl -L {} -o {/}

[wget]: https://www.gnu.org/software/wget/
[curl]: https://curl.haxx.se/
[xargs]: https://en.wikipedia.org/wiki/Xargs
[GNU parallel]: http://www.gnu.org/software/parallel/
[parallels-tutorial]: https://www.gnu.org/software/parallel/parallel_tutorial.html

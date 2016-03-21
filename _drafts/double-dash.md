---
layout: post
title:  "Double Dash"
date:   2014-07-13 00:36:31
categories: 
       bash

published: false
---

If you're anything like me you'll find your directories liberally scattered
with some pretty strange directory and file names.

```
$ ls -la

-rw-r--r--   1 gypsydave5  1482096370   647 11 Oct 20:15 :w
drwxr-xr-x   2 gypsydave5  1482096370    68 10 Feb 08:55 -p/
-rw-r--r--   1 gypsydave5  1482096370  2900 11 Oct 20:15 \(
```

Hopefully you're nothing like me and you never get this, but I'm both a sloppy
and impatient typist and so I will <del>occasionally</del> often mash the
keyboard in Vim and name a file after the write command, or somehow create
a directory called `-p` because I was using the recursive flag on `mkdir`.[^1]

On that subject, let's try and get rid of the `-p` directory:

```
$ rm -rf -p

rm: illegal option -- p
usage: rm [-f | -i] [-dPRrvW] file ...
       unlink file
```

Hmmm, that sucks. What about...

```
$ rm -rf "-p"

rm: illegal option -- p
usage: rm [-f | -i] [-dPRrvW] file ...
       unlink file
```

Ummm...

```
$ rm -rf "\-p"
```

Yay!
fast
```
$ ls -la

-rw-r--r--   1 gypsydave5  1482096370   647 11 Oct 20:15 :w
drwxr-xr-x   2 gypsydave5  1482096370    68 10 Feb 08:55 -p/
-rw-r--r--   1 gypsydave5  1482096370  2900 11 Oct 20:15 \(
```

Boo. Happily there's a *nix convention to help with these situations: `--`.
Double-dash tells the command you're running that everything that comes after
it is not to be treated as a command option, but is instead a filename. So:

```
$ rm -rf -- -p
$ ls -la

-rw-r--r--   1 gypsydave5  1482096370   647 11 Oct 20:15 :w
drwxr-xr-x   2 gypsydave5  1482096370    68 10 Feb 08:55 -p/
-rw-r--r--   1 gypsydave5  1482096370  2900 11 Oct 20:15 (
```

DISCO!

[^1]: I'm _still_ not sure how I managed this. But I'm staring at the evidence now, so I know it must've happened.


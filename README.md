gypsydave5.github.io
====================

This is my blog, hosted with Github Pages, available at both
[blog.gypsydave5.com](https://blog.gypsydave5.com) and
[gypsydave5.github.io](https://gypsydave5.github.io).

It was created using [blawg][blawg], a static site generator I wrote.

To build the site, first install `blawg` (which depends on [Go][golang])

```shell
go install git.sr.ht/~dew/blawg/blawg@latest
```

and then just run

```shell
blawg
```

in the project directory

To serve locally, you can use any one of the [plethora of one-liners][one-line-static],
or there's a Go 'script' you can run:

```shell
go run serve.go
```

and just head to `localhost:3333`.

To publish, there's a `publish.sh` script.

```shell
./publish.sh
```

[blawg]: https://git.sr.ht/~dew/blawg
[golang]: https://golang.org/doc/install
[one-line-static]: https://gist.github.com/willurd/5720255


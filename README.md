gypsydave5.github.io
====================

This is my blog, hosted with Github Pages, available at both
[blog.gypsydave5.com](blog.gypsydave5.com) and
[gypsydave5.github.io](gypsydave5.github.io).

It was created using [blawg][blawg], a static site generator I wrote.

To build the site, first install `blawg` (which depends on [Go][golang])

```shell
go get https://github.com/gypsydave5/blawg/blawg
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

and just head to `localhost:8000`.

To publish, there's a `publish.sh` script.

```shell
./publish.sh
```

[blawg]: https://github.com/gypsydave5/blawg
[golang]: https://golang.org/doc/install
[one-line-static]: https://gist.github.com/willurd/5720255


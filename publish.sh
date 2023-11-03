#!/bin/bash -e
blawg

TEMPDIR=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`

cp -r site/. $TEMPDIR
pushd $TEMPDIR

aws s3 sync . s3://blog.gypsydave5.com --profile=gypsydave5

popd $TEMPDIR
rm -rf $TEMPDIR


#!/bin/bash -e
blawg

TEMPDIR=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`

cp -r site/. $TEMPDIR
pushd $TEMPDIR

git init
git add .
git status
git commit -m "Updating site from blawg at $(date)"
git remote add origin git@github.com:gypsydave5/gypsydave5.github.io
git push origin master --force
aws s3 sync . s3://blog.gypsydave5.com --profile=gypsydave5

popd $TEMPDIR
rm -rf $TEMPDIR


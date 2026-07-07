#!/bin/bash -e
blawg
aws s3 sync site/. s3://blog.gypsydave5.com --profile=gypsydave5 --delete

#!/usr/bin/env bash
if [[ ! $1 ]]
then
  echo "Input BUCKET_NAME TO clean up!"
  exit 9
fi
NAME_BUCKET=$1
aws --profile mfa s3 rb --force s3://$NAME_BUCKET

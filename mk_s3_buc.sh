#!/usr/bin/env bash
if [[ ! $1 ]]
then
  echo "Plz input s3 bucket name(unique in s3 world)"
  exit 9
fi
NAME_BUCKET=$1
aws --profile mfa s3 mb s3://$NAME_BUCKET

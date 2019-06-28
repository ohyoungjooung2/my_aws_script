#!/usr/bin/env bash
if [[ ! $1 ]]
then
  echo "Plz input TARGET DIR TO SYNC"
  echo "usage: ./$0 TARGET_DIR NAME_BUCKET"
  exit 9
fi
if [[ ! $2 ]]
then
  echo "Plz input s3 bucket name(unique in s3 world)"
  exit 9
fi
NAME_BUCKET=$2
SYNC_TARGET=$1
aws --profile mfa s3 sync $SYNC_TARGET s3://$NAME_BUCKET

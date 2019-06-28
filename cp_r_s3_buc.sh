#!/usr/bin/env bash
if [[ ! $1 ]]
then
  echo "Plz input NAME OF BUCKET TO COPY(CP)"
  echo "usage: ./$0 NAME_BUCKET TARGET_DIR"
  exit 9
fi
if [[ ! $2 ]]
then
  echo "Plz input s3 bucket name(unique in s3 world)"
  exit 9
fi
NAME_BUCKET=$1
TARGET_DIR=$2
aws --profile mfa s3 cp --recursive s3://$NAME_BUCKET $TARGET_DIR

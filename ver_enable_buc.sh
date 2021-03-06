#!/usr/bin/env bash
if [[ ! $1 ]]
then
  echo "Plz input s3 bucket name(unique in s3 world)"
  exit 9
fi
NAME_BUCKET=$1
aws --profile mfa s3api put-bucket-versioning --bucket $NAME_BUCKET --versioning-configuration Status=Enabled
echo "Listing list-object-versions"
aws --profile mfa s3api list-object-versions --bucket $NAME_BUCKET


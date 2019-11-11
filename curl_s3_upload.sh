#!/bin/bash
#From https://github.com/wachtelbauer/linux-shell-scripts/blob/master/S3-AWS4-Upload.sh
#Many many thanks!
#This script for uploading files into s3 bucket that is public?

HMAC-SHA256s(){
 KEY="$1"
 DATA="$2"
 shift 2
 printf "$DATA" | openssl dgst -binary -sha256 -hmac "$KEY" | od -An -vtx1 | sed 's/[ \n]//g' | sed 'N;s/\n//'
}

HMAC-SHA256h(){
 KEY="$1"
 DATA="$2"
 shift 2
 printf "$DATA" | openssl dgst -binary -sha256 -mac HMAC -macopt "hexkey:$KEY" | od -An -vtx1 | sed 's/[ \n]//g' | sed 'N;s/\n//'
}

#aws keys as args
AWS_SECRET_KEY=$1
AWS_ACCESS_KEY=$2

FILE_TO_UPLOAD="file.zip"
BUCKET="bucket_name"
STARTS_WITH="folder_name"

REQUEST_TIME=$(date +"%Y%m%dT%H%M%SZ")
REQUEST_REGION="ap-northeast-2"
REQUEST_SERVICE="s3"
REQUEST_DATE=$(printf "${REQUEST_TIME}" | cut -c 1-8)
AWS4SECRET="AWS4"$AWS_SECRET_KEY
ALGORITHM="AWS4-HMAC-SHA256"
EXPIRE="2030-01-01T00:00:00.000Z"
ACL="private"

POST_POLICY='{"expiration":"'$EXPIRE'","conditions": [{"bucket":"'$BUCKET'" },{"acl":"'$ACL'" },["starts-with", "$key", "'$STARTS_WITH'"],["eq", "$Content-Type", "application/octet-stream"],{"x-amz-credential":"'$AWS_ACCESS_KEY'/'$REQUEST_DATE'/'$REQUEST_REGION'/'$REQUEST_SERVICE'/aws4_request"},{"x-amz-algorithm":"'$ALGORITHM'"},{"x-amz-date":"'$REQUEST_TIME'"}]}'

UPLOAD_REQUEST=$(printf "$POST_POLICY" | openssl base64 )
UPLOAD_REQUEST=$(echo -en $UPLOAD_REQUEST |  sed "s/ //g")

SIGNATURE=$(HMAC-SHA256h $(HMAC-SHA256h $(HMAC-SHA256h $(HMAC-SHA256h $(HMAC-SHA256s $AWS4SECRET $REQUEST_DATE ) $REQUEST_REGION) $REQUEST_SERVICE) "aws4_request") $UPLOAD_REQUEST)

curl --silent \
        -F "key=""$STARTS_WITH" \
        -F "acl="$ACL"" \
        -F "Content-Type="application/octet-stream"" \
        -F "x-amz-algorithm="$ALGORITHM"" \
        -F "x-amz-credential="$AWS_ACCESS_KEY/$REQUEST_DATE/$REQUEST_REGION/$REQUEST_SERVICE/aws4_request"" \
        -F "x-amz-date="$REQUEST_TIME"" \
        -F "Policy="$UPLOAD_REQUEST"" \
        -F "X-Amz-Signature="$SIGNATURE"" \
        -F "file=@"$FILE_TO_UPLOAD http://$BUCKET.s3.amazonaws.com/
~                                                                              

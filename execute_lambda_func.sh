#!/usr/bin/env bash
#This script a example than execute 'getUser' aws lambda function.
A=$(aws --profile mfa lambda invoke --function-name getUser --log-type Tail --payload '{"key1":""}' outputfile.txt)
R=$(echo $A | awk -F"," '{print $1}' | awk -F":" '{print $2}' | sed 's/^ //g'| sed 's/\"//g' | base64 --decode)
echo $R

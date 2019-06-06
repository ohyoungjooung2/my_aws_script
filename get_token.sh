#!/usr/bin/env bash
#This script is for gen sts token for the user is prohibited using cli because of mfa session of iam policy
if [[ -z $1 ]]
then
  echo "Input token of your mfa devices"
  exit 1
fi

DS=129600
ARNMFA="arn:aws:iam::xxxxxxxxxxxx:mfa/tester"
DFILE="$HOME/.aws/credentials"
#AWG=$(aws sts get-session-token --serial-number $ARNMFA --token-code $1)
AWG=$(aws sts get-session-token --serial-number $ARNMFA --token-code $1 --duration-seconds $DS)
AID=$(echo $AWG | awk -F',' '{print $4}' | awk -F': ' '{print $2}' | awk '{print $1}' | sed 's/\"//g')
SGK=$(echo $AWG | awk -F',' '{print $1}' | awk -F': ' '{print $3}' | sed 's/\"//g')
ST=$(echo $AWG | awk -F',' '{print $2}' | awk -F': ' '{print $2}' | sed 's/\"//g')
echo $AWG
echo $AID
echo $SGK
echo $ST
sed -i "2s%.*%aws_access_key_id = $AID%g" $DFILE
sed -i "3s%.*%aws_secret_access_key = $SGK%g" $DFILE
sed -i "4s%.*%aws_session_token = $ST%g" $DFILE

if [[ $? == "0" ]]
then
   echo "Successful adjusting mfa token to $DFILE"
else
   echo "Failed adjusting mfa token to $DFILE"
   exit 1
fi
echo $?

# {
#            "Sid": "DenyAllExceptListedIfNoMFA",
#            "Effect": "Deny",
#            "NotAction": [
#                "iam:CreateVirtualMFADevice",
#                "iam:EnableMFADevice",
#                "iam:GetUser",
#                "iam:ListMFADevices",
#                "iam:ListVirtualMFADevices",
#                "iam:ResyncMFADevice",
#                "sts:GetSessionToken"
#            ],
#            "Resource": "*",
#            "Condition": {
#                "BoolIfExists": {
#                    "aws:MultiFactorAuthPresent": "false"
#                }
#            }
#        }

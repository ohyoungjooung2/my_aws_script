#!/usr/bin/env bash
usag(){
  if [[ -z $1 ]]
  then
     echo "Usage: $0 security_group_name vpc-id"
     exit 1
  fi
}  

getvpc(){
  if [[ -z $2 ]]
  then
     echo "getting default vpc vpc-2542b84d"
     VPC_ID="vpc-2542b84d"
  fi
}


usag $1
getvpc


A=`which aws`
MYIP=`curl -s ipinfo.io/ip`
$A ec2 create-security-group --group-name $1 --vpc-id $VPC_ID --description "security group for dev"


echo "creating cidr ingress"
$A ec2 authorize-security-group-ingress --group-name $1 --protocol tcp --port 22 --cidr $MYIP/32

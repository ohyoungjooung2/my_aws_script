#!/usr/bin/env bash
#aws command find
A=`which aws`
if [[ -z $A ]]
then
   echo "No aws command cli found, plz install it"
   exit
fi

#Delete current's pem file first
del_key(){
   if [[ -e ./$1.pem ]]
   then
     echo "$1.pem exist in current directory so removing"
     rm -fv $1.pem
   fi
}

#list key pairs
list_key(){
   $A ec2 describe-key-pairs
}

list_instance_ids(){
   $A ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId'
}
stop_instance(){
   $A ec2 stop-instances --instance-id $1
}

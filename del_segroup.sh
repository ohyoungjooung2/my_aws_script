. ./common.sh
usag(){
   if [[ -z $1 ]]
   then
      echo "./$0 security-group-id"
      exit 1
   fi
}

usag $1

$A ec2 delete-security-group --group-id $1

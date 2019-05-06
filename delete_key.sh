. ./common.sh
usage(){
   if [[ -z $1 ]] 
   then
     echo "usage: $0 key_name that you want to delete"
     exit 1
   fi
}
usage $1

echo "Removing current dir's key $1.pem"
$A ec2 delete-key-pair --key-name $1

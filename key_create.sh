. ./common.sh
usage(){
   if [[ -z $1 ]] 
   then
     echo "usage: $0 key_name that you want"
     exit 1
   fi
}
usage $1

del_key(){
   if [[ -e ./$1.pem ]]
   then
     echo "$1.pem exist in current directory so removing"
     rm -fv $1.pem
   fi
}

del_key $1

$A ec2 create-key-pair --key-name $1 --query 'KeyMaterial' --output text > $1.pem
chmod 400 $1.pem

list_key

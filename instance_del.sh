. ./common.sh
usag(){
  if [[ -z $1 ]]
  then
    echo "Usage: $0 instance-id"
    exit 0
  fi
}
usag $1


#Just delete instance, no delete volume elastic-ip
$A opsworks delete-instance --instance-id $1

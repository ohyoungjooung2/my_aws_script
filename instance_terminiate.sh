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
$A ec2 terminate-instances --instance-ids $1

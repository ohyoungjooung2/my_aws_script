. ./common.sh
$A ec2 stop-instances --instance-ids $1
$A ec2 describe-instance-status --instance-ids $1 --output text | grep -i code


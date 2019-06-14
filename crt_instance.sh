. ./common.sh
IMAGE_ID="ami-047f7b46bd6dd5d84"
INSTANCE_TYPE="t2.micro"
KEY_NAME="test"
SGGROUPS="sg-61bd2e0b"
#SUBNET="subnet-4d383500"
#aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-xxxxxxxx --subnet-id subnet-xxxxxxxx
#aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type $INSTANCE_TYPE --key-name test --security-group-ids $SGGROUPS --subnet-id $SUBNET
aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type $INSTANCE_TYPE --key-name test --security-group-ids $SGGROUPS

. ./common.sh
while true
do
 RESULT=$($A ec2 stop-instances --instance-ids $1  | grep -i code | awk  '{print $2}' | awk  -F',' '{print $1}' |uniq)
 #RESULT=$($A ec2 stop-instances --instance-ids $1  | grep -i code | awk  '{print $2}')
 sleep 3
 echo $RESULT
 echo "Stopping $1!"
 if [[ $RESULT == "80" ]]
 then
	   echo "instance $1 stopped"
	   echo "Now start change instance type $1"
	   $A ec2 modify-instance-attribute --instance-id $1 --instance-type  "{\"Value\": \"$2\"}"
	   GETYPE=$(aws ec2 describe-instances --instance-id i-063bdd5766ef0ea5c --query 'Reservations[*].Instances[*].{Instance:InstanceType}' --output text)
	   echo $GE
	   if [[ $2 == $GETYPE ]]
	   then
		   echo "Changed type oK! $2"
		   sleep 1
		   echo "Starting chaged $2 $1 instance"
		   $A ec2 start-instances --instance-ids $1
	           exit 0
	   else
		   echo "Changed type not oK! $2"
		   exit 1
	   fi
 fi
done

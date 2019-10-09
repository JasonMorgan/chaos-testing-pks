#!/bin/bash
# With console access

## AWS CLI commands

if [ -z "$1" ]
then
      echo "Add an AZ, us-east1a || us-east1b || us-east1c"
      exit 0
fi
AZ="$1"

echo "deleting nodes in AZ $AZ"
for i in $(aws ec2 describe-instances  --filter 'Name=tag:Name,Values=worker/*' --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' | 
jq -r --arg AZ "$AZ" '.[] | .[] | select(.AZ | test($AZ)).Instance') 
do 
  aws ec2 terminate-instances --instance-ids "$i" > /dev/null
done

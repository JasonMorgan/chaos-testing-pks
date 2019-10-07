#!/bin/bash

aws ec2 describe-instances  --filter 'Name=tag:Name,Values=worker/*' \
--query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' \
 --output table | grep running
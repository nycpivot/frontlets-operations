#!/bin/bash

AWS_REGION_CODE=$(aws configure get region)

stack_name=media-server-stack

profile_name=heirwaves-media-server-profile-$AWS_REGION_CODE
role_name=heirwaves-media-server-role-$AWS_REGION_CODE

echo
echo "Deleting stack..."
echo

aws cloudformation delete-stack --stack-name $stack_name --region ${AWS_REGION_CODE}
aws cloudformation wait stack-delete-complete --stack-name $stack_name --region ${AWS_REGION_CODE}

echo
echo "Deleting instance profile and role..."
echo

aws iam remove-role-from-instance-profile --instance-profile-name $profile_name --role-name $role_name

aws iam delete-instance-profile --instance-profile-name $profile_name

aws iam detach-role-policy --role-name $role_name --policy arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam detach-role-policy --role-name $role_name --policy arn:aws:iam::aws:policy/SecretsManagerReadWrite
aws iam detach-role-policy --role-name $role_name --policy arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

aws iam delete-role --role-name $role_name

echo
echo "DONE"
echo

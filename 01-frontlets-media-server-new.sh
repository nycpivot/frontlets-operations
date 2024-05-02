#!/bin/bash

read -p "Stack Name (frontlets-media-server-stack): " stack_name
read -p "Server Name (frontlets-media-server): " server_name
read -p "AWS Region Code (us-east-1): " aws_region_code

if [[ -z $stack_name ]]
then
	stack_name=frontlets-media-server-stack
fi

if [[ -z $server_name ]]
then
	server_name=frontlets-media-server
fi

if [[ -z $aws_region_code ]]
then
	aws_region_code=us-east-1
fi

dns=media.frontlets.net

elastic_ip=$(aws ec2 describe-addresses --query Addresses[0].PublicIp --output text)
profile_name=frontlets-media-server-profile-$aws_region_code
role_name=frontlets-media-server-role-$aws_region_code

vpc_id=$(aws ec2 describe-vpcs \
	--region ${aws_region_code} \
	--filter "Name=isDefault,Values=true" \
	--query "Vpcs[].VpcId" \
	--output text)

if [[ -z $vpc_id ]]
then
	read -p "VPC Id: " vpc_id
fi

aws cloudformation create-stack \
	--stack-name ${stack_name} \
	--region ${aws_region_code} \
	--parameters ParameterKey=MediaServerName,ParameterValue=${server_name} \
	--parameters ParameterKey=VpcId,ParameterValue=${vpc_id} \
	--template-body file://config/frontlets-media-server-template.yaml

echo
echo "Creating resources..."
echo

aws cloudformation wait stack-create-complete --stack-name ${stack_name} --region ${aws_region_code}

key_id=$(aws ec2 describe-key-pairs \
	--region ${aws_region_code} \
	--filters Name=key-name,Values=frontlets-media-server-keypair \
	--query KeyPairs[*].KeyPairId \
	--output text)

if [ ! -d "keys" ]
then
	mkdir keys
fi

if test -f keys/frontlets-media-server-keypair-${aws_region_code}.pem; then
	rm keys/frontlets-media-server-keypair-${aws_region_code}.pem
fi

aws ssm get-parameter \
	--name " /ec2/keypair/${key_id}" \
	--region ${aws_region_code} \
	--query Parameter.Value \
	--with-decryption \
	--output text > keys/frontlets-media-server-keypair-${aws_region_code}.pem

echo

instance_id=$(aws cloudformation describe-stacks \
	--stack-name ${stack_name} \
	--region ${aws_region_code} \
  --query "Stacks[0].Outputs[?OutputKey=='InstanceId'].OutputValue" --output text)

aws opsworks associate-elastic-ip \
	--region $aws_region_code \
	--instance-id $instance_id \
	--elastic-ip $elastic_ip

# create instance profile for EC2 instance
aws iam create-instance-profile --instance-profile-name $profile_name

# create role and attach policy to allow it access to services
aws iam create-role --role-name $role_name --assume-role-policy-document file://config/trust-policy.json --no-cli-pager
aws iam attach-role-policy --role-name $role_name --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess --no-cli-pager
aws iam attach-role-policy --role-name $role_name --policy-arn arn:aws:iam::aws:policy/SecretsManagerReadWrite --no-cli-pager
aws iam attach-role-policy --role-name $role_name --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy --no-cli-pager

aws iam add-role-to-instance-profile --instance-profile-name $profile_name --role-name $role_name --no-cli-pager

sleep 10 # the following line works if run manually after the above has run
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=$profile_name --instance-id $instance_id --no-cli-pager

# wget http://169.254.169.254/latest/dynamic/instance-identity/document -O metadata
# aws_region_code=$(cat metadata | jq -r .region)

aws configure set default.region $aws_region_code

# dns for media.frontlets.net
hosted_zone_id=Z0751888SKYR8JH75BJ6

# ipaddress=$(aws cloudformation describe-stacks \
# 	--stack-name ${stack_name} \
# 	--region ${aws_region_code} \
# 	--query "Stacks[0].Outputs[?OutputKey=='PublicIpAddress'].OutputValue" --output text)

mkdir $HOME/tmp

change_batch_filename=change-batch-$RANDOM
cat <<EOF | tee $HOME/tmp/$change_batch_filename.json
{
    "Comment": "Update record.",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "$dns",
                "Type": "A",
                "TTL": 60,
                "ResourceRecords": [
                    {
                        "Value": "${elastic_ip}"
                    }
                ]
            }
        }
    ]
}
EOF
echo

aws route53 change-resource-record-sets \
  --hosted-zone-id $hosted_zone_id \
  --change-batch file:///$HOME/tmp/$change_batch_filename.json

rm $HOME/tmp/$change_batch_filename.json
echo

echo
echo "*** SERVER DNS ***"

aws cloudformation describe-stacks \
	--stack-name ${stack_name} \
	--region ${aws_region_code} \
	--query "Stacks[0].Outputs[?OutputKey=='PublicDnsName'].OutputValue" --output text

echo "******************"
echo

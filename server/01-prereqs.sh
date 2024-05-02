#!/bin/bash

sudo apt update
# yes | sudo apt upgrade

sudo apt-get install tree

# the following works best on ubuntu 22.04
sudo apt-get install -y dotnet-sdk-8.0

# the following works best on ubuntu 20.04

# # Get OS version info
# source /etc/os-release

# # Download Microsoft signing key and repository
# wget https://packages.microsoft.com/config/$ID/$VERSION_ID/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# # Install Microsoft signing key and repository
# sudo dpkg -i packages-microsoft-prod.deb

# # Clean up
# rm packages-microsoft-prod.deb

# # Update packages
# sudo apt update

# sudo apt install aspnetcore-runtime-8.0


# install tool to mount to s3 (need debian version)
#wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm


# install unified cloudwatch agent
sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

sudo rm amazon-cloudwatch-agent.deb

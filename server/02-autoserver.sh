#!/bin/sh

apt update

apt-get install unzip -y

apt install software-properties-common && add-apt-repository ppa:jonathonf/ffmpeg-4 -y

apt update && apt install nginx -y

sudo apt-get install libnginx-mod-rtmp -y

apt install ffmpeg libavdevice58 -y

apt install libpcre3-dev libssl-dev build-essential zlib1g-dev -y

cd /root/

# Download nginx from source 
wget https://frontlets-storage.s3.us-east-1.amazonaws.com/nginx.zip # https://up.ecarinfo.net/.nginx.zip

cd /root/

unzip nginx.zip

mv /etc/nginx /etc/nginxold

cp -R /root/nginx /etc/

# # custom
# sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.backup
# sudo cp ~/fourwindsradio-operations/config/nginx.conf /etc/nginx
# # custom

service nginx restart 

cd /root/

rm -rf nginx

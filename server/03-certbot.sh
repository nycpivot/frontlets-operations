#!/bin/bash

sudo apt-get install python3-certbot-nginx

# creates a shortcut from /usr/bin if installed with snap
# sudo ln -s /snap/bin/certbot /usr/bin/certbot

# need to run this in order to install all the files
# in the /etc/letsencypt folder because these files are
# referred to in the nginx.conf file
sudo certbot --nginx -d media.heirwaves.net

# custom - replace conf file with media server settings
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.backup
sudo cp /home/ubuntu/heirwaves-operations/config/nginx.conf /etc/nginx
# custom

sudo service nginx restart

# run this again now all the necessary files are in place?!?
# it's lame but it works
sudo certbot --nginx -d media.heirwaves.net

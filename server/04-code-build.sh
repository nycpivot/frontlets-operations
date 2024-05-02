#!/bin/bash

sudo rm -rf /tmp/frontlets-media-server
git clone https://github.com/nycpivot/frontlets-media-server /tmp/frontlets-media-server

cd /tmp/frontlets-media-server/src/Frontlets.Media.Server

sudo rm -rf /var/lib/frontlets-media-server
sudo dotnet publish -c Release -o /var/lib/frontlets-media-server

sudo rm /etc/systemd/system/Frontlets.Media.Server.service
sudo cp Frontlets.Media.Server.service /etc/systemd/system
# sudo cp Frontlets.Media.Server.service /etc/systemd/system

#!/bin/bash

sudo rm -rf frontlets-media-server
git clone https://github.com/nycpivot/frontlets-media-server

cd frontlets-media-server/src/Frontlets.Media.Server

sudo rm -rf /var/lib/frontlets-media-server
sudo dotnet publish -c Release -o /var/lib/frontlets-media-server

# sudo rm /var/lib/heirwaves-media-server/appsettings.json
# sudo cp ~/appsettings.Production.json /var/lib/heirwaves-media-server

sudo rm /etc/systemd/system/Frontlets.Media.Server.service
sudo cp Frontlets.Media.Server.service /etc/systemd/system
# sudo cp Frontlets.Media.Server.service /etc/systemd/system

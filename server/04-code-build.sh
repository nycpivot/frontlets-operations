#!/bin/bash

sudo rm -rf heirwaves-media-server
git clone https://github.com/nycpivot/heirwaves-media-server

cd heirwaves-media-server/src/HeirWaves.Media.Server

sudo rm -rf /var/lib/heirwaves-media-server
sudo dotnet publish -c Release -o /var/lib/heirwaves-media-server

# sudo rm /var/lib/heirwaves-media-server/appsettings.json
# sudo cp ~/appsettings.Production.json /var/lib/heirwaves-media-server

sudo rm /etc/systemd/system/HeirWaves.Media.Server.service
sudo cp HeirWaves.Media.Server.service /etc/systemd/system
# sudo cp HeirWaves.Media.Server.service /etc/systemd/system

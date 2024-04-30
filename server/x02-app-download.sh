#!/bin/bash

wget https://fourwindsradio.blob.core.windows.net/fourwindsradio/fourwindsradio-media-server.zip

sudo rm -rf /var/lib/fourwindsradio-media-server
sudo unzip fourwindsradio-media-server.zip -d /var/lib
sudo rm fourwindsradio-media-server.zip

sudo rm /etc/systemd/system/FourWindsRadio.Media.Server.service
sudo cp ~/FourWindsRadio.Media.Server.service /etc/systemd/system

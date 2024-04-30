#!/bin/bash

cd ~

sudo rm -rf playlist

sudo systemctl daemon-reload

# sudo systemctl start Frontlets.Media.Server
sudo systemctl restart Frontlets.Media.Server
sudo systemctl enable Frontlets.Media.Server

sudo systemctl status Frontlets.Media.Server

# sudo journalctl -u Frontlets.Media.Server -f

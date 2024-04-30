#!/bin/bash

cd ~

sudo rm -rf playlist

sudo systemctl daemon-reload

# sudo systemctl start HeirWaves.Media.Server
sudo systemctl restart HeirWaves.Media.Server
sudo systemctl enable HeirWaves.Media.Server

sudo systemctl status HeirWaves.Media.Server

# sudo journalctl -u HeirWaves.Media.Server -f

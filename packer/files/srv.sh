#!/bin/bash

# Install MongoDB
echo "Install MongoDB"
sudo apt update && sudo apt install -y mongodb
echo "Start and enable MongoDB"
sudo systemctl start mongodb
sudo systemctl enable mongodb
echo "view mongoDB"
sudo systemctl status mongodb

# Install Ruby & Bundler
echo "Install Ruby & Bundler"
sudo apt update && sudo apt install -y ruby-full ruby-bundler build-essential
echo " "
echo "View versions of ruby and bundler"
ruby -v

# Install reddit app & git
sudo apt update && sudo apt install -y git
mkdir /opt/reddit-app
cd /opt/reddit-app
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

tee /etc/systemd/system/reddit-app.service<<EOF
[Unit]
Description=reddit app hw5
Wants=network-online.target
After=network-online.target

[Service]
WorkingDirectory=/opt/reddit-app/reddit
ExecStart=/usr/local/bin/puma
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl enable reddit-app

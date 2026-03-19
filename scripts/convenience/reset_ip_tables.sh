#!/usr/bin/env bash

sudo ufw disable
sudo systemctl stop ufw
sudo ufw reset
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
sudo systemctl start ufw
sudo ufw status verbose

echo "Completed reset ufw"

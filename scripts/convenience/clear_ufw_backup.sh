#!/usr/bin/env bash

cd /etc/ufw
sudo find . -type f | grep -E '\.[0-9]{8}_[0-9]{6}$'

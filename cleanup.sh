#!/usr/bin/env bash

echo "Removing unnecessary packages ..."
apt-get autoremove -y

echo "Removing APT cache ..."
apt-get clean -y

echo "Zeroing Out empty drive space ..."
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

echo "Clearing shell history ..."
history -c

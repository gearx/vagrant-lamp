#!/usr/bin/env bash

# Remove unnecessary packages
apt-get autoremove

# Remove APT cache
apt-get clean

# Zero out drive
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Clear shell history
history -c

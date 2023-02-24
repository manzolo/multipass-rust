#!/bin/bash
echo "Remove needrestart..."
sudo apt -y remove needrestart > /dev/null
echo "Upgrade packages..."
DEBIAN_FRONTEND=noninteractive sudo apt -qqy update > /dev/null
DEBIAN_FRONTEND=noninteractive sudo apt -qqy upgrade > /dev/null

#!/usr/bin/env bash
echo "==> [ Entering Base ]"

# Reset home directory of vagrant user
if ! grep -q "cd /var/www" /home/vagrant/.profile; then
    echo "cd /var/www" >> /home/vagrant/.profile
fi

echo "==> Updating apt-get-get..."
apt-get update

echo "==> Installing/updating build-essential..."
apt-get install -y build-essential

# DOS2UNIX
if [ ! -f /usr/bin/dos2unix ]; then
    echo "==> Installing dos2unix..."
    apt-get install -y dos2unix
fi

# GIT
if [ ! -f /usr/bin/git ]; then
    echo "==> Installing GIT..."
    apt-get install -y git
fi

# CURL
if [ ! -f /usr/bin/curl ]; then
    echo "==> Installing CURL..."
    apt-get install -y curl
fi

if [ ! -f /usr/bin/zip ]; then
    echo "==> Installing zip..."
    apt-get install zip unzip
fi
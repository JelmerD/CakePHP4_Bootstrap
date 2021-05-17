#!/usr/bin/env bash
echo "==> [ Entering Apache ]"

# APACHE
if [ ! -d /etc/apache2 ]; then
    echo "==> Installing Apache2..."
    apt-get install -y apache2
    a2enmod rewrite
fi

echo "==> restarting services..."
service apache2 restart
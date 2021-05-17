#!/usr/bin/env bash
echo "==> [ Entering Database ]"



# MARIADB
if [ ! -f /usr/bin/mariadb ]; then
    echo "==> Installing MariaDB..."
    apt-get install -y mariadb-client mariadb-server
fi

echo "==> restarting services..."
service mariadb restart
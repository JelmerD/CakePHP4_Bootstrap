#!/usr/bin/env bash
echo "==> [ Entering PHP ]"

# PHP
if [ ! -f /usr/bin/php ]; then
    echo "==> Installing PHP..."
    # required by CakePHP
    apt-get install -y php7.3 php7.3-mbstring php7.3-intl php7.3-mysql php7.3-sqlite3
    # these are not...
    apt-get install -y php7.3-cli php7.3-curl php7.3-json php7.3-xdebug php7.3-zip
    # needed for phpunit
    apt-get install -y php7.3-xml php-zip
fi

# COMPOSER - needs php to install
if [ -e /usr/local/bin/composer ]; then
    echo "==> updating composer..."
    /usr/local/bin/composer self-update
else
    echo "==> Installing composer..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi
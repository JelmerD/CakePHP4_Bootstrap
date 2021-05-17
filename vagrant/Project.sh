#!/usr/bin/env bash
echo "==> [ Entering Project ]"

# CD into home directory
cd /var/www

# VARS
APACHE_LOG_DIR="/home/vagrant"
DATABASE_NAME="cake_project"

# Configure Apache
echo "<VirtualHost *:80>
    DocumentRoot /var/www/webroot
    AllowEncodedSlashes On
    <Directory /var/www/webroot>
        Options +Indexes +FollowSymLinks
        DirectoryIndex index.php index.html
        Order allow,deny
        Allow from all
        AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/apache2_error.log
    CustomLog ${APACHE_LOG_DIR}/apache2_access.log combined
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

echo "==> Creating database..."
echo "CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME} DEFAULT CHARACTER SET utf8" | mysql -uroot -proot
echo "CREATE DATABASE IF NOT EXISTS debug_kit DEFAULT CHARACTER SET utf8" | mysql -uroot -proot
echo "CREATE DATABASE IF NOT EXISTS test DEFAULT CHARACTER SET utf8" | mysql -uroot -proot
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root'" | mysql -uroot -proot
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION" | mysql -uroot -proot
echo "flush privileges" | mysql -uroot -proot

echo "==> restarting services..."
service apache2 restart
service mariadb restart

if [ -f index.php ]; then
    # Check that all packages are installed
    if [ -f composer.lock ]; then
            # we need to to --prefer-source because if we don't, it throws an error
            # https://stackoverflow.com/questions/26216437/error-could-not-delete-with-composer-on-vagrant
            echo "==> Installing composer packages..."
            composer install --prefer-source
    fi

    # TODO implement this
    #echo "==> Migrating the database tables..."
    #bin/cake migrations migrate

    # use the custom bash script to throw in some basic to use data that we need
    # echo "==> adding data to the database..."
    # bash data/dump recover

    # Make sure that the app_local.php exists
    if [ ! -f config/app_local.php ]; then
      echo "==> Copying config file..."
      cp config/app_local.example.php config/app_local.php
    fi

    echo "==================================================="
    echo "| WE'RE DONE HERE. NOW GOTO HTTP://LOCALHOST:8080 |"
    echo "==================================================="
fi

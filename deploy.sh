#!/usr/bin/env bash

read -p "Are you sure you want to deploy? This wil undo any made changes [y/n]: " CONDITION;
if [ "$CONDITION" != "y" ]; then
    echo -e "\e[33mOkay, shutting down\e[39m"
    exit 1;
fi

echo -e "\e[33m--------------------------------------------------------------------------------------------------\e[39m"

# undo made changes on the server
echo -e "\e[33mResetting branch\e[39m"
git reset --hard

echo -e "\e[33m--------------------------------------------------------------------------------------------------\e[39m"

# pull the new release
echo -e "\e[33mPulling the new stuff\e[39m"
git pull origin master

echo -e "\e[33m--------------------------------------------------------------------------------------------------\e[39m"

# install all dependencies
# without dev stuff, and optimize the autoloader
echo -e "\e[33mInstall all the dependencies and optimize the autoloader\e[39m"
composer install --no-dev -o

echo -e "\e[33m--------------------------------------------------------------------------------------------------\e[39m"

# make sure cake is executable
chmod +x bin/cake

# update the database
echo -e "\e[33mUpdate the database\e[39m"
bin/cake migrations migrate

echo -e "\e[33m--------------------------------------------------------------------------------------------------\e[39m"

# clear the orm cache
echo -e "\e[33mClear all caches\e[39m"
bin/cake cache clear default
bin/cake cache clear _cake_core_
bin/cake cache clear _cake_model_
bin/cake cache clear _cake_routes_

echo -e "\e[33m--------------------------------------------------------------------------------------------------\e[39m"

echo -e "\e[33mLooks like we're done here, bai\e[39m"
exit 1

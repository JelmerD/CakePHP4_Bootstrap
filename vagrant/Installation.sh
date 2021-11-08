#!/usr/bin/env bash
echo "==> [ Entering Initial project installation ]"

# CD into home directory
cd /var/www

# for some reason there might be a HTML directory, make sure to delete this
if [ -d html/ ]; then
    echo "==> Removing html directory"
    rm html/ -Rf
fi

# if there is no CAKE project installed
if [ ! -f index.php ]; then

    # Check if the temporary project is installed
    if [ ! -d tmp_app/ ]; then
        # If this is NOT the case (step 1 of the setup)

        echo "=================================================================================================="
        echo "| No CakePHP project installed so we need to do some stuff.."
        echo "|"
        echo "| We will delete the .git directory in order to make sure that there won't be any conflicts, do 'git remote add origin URL' yourself"
        echo "|"
        echo "| A BLANK CAKEPHP PROJECT NEEDS TO BE INSTALLED MANUALLY"
        echo "| This is because you need to answer 2 questions (1st: no, 2nd: yes)"
        echo "|"
        echo "| Run: 'composer create-project --prefer-source cakephp/app:~4.0 tmp_app' from the /var/www directory"
        echo "| Use putty.exe to login on vagrant@localhost:2222 with vagrant:vagrant"
        echo "|"
        echo "| After you did this, run 'vagrant provision' once more to finalize setup"
        echo "=================================================================================================="

        # there is probably a .git dir present, make sure to get rid of it
        if [ -d .git/ ]; then
          echo "==> Removing .git directory to prevent VCS errors"
          chmod -R 777 .git #make sure we have the rights to do so
          rm .git/ -Rf
        fi

    else
        # if there is a tmp app, do this (step 2 of setup)

        if [ -d tmp_app/.git/ ]; then
          echo "==> Removing tmp_app/.git directory to prevent VCS errors"
          rm tmp_app/.git/ -Rf
        fi

        if [ -d tmp_app/.github/ ]; then
          echo "==> Removing tmp_app/.github directory"
          rm tmp_app/.github/ -Rf
        fi

        if [ -f tmp_app/readme.md ]; then
          echo "==> Removing app/readme.md"
          rm tmp_app/readme.md
        fi

        echo "==> Moving contents of tmp_app/ directory to /var/www"
        shopt -s dotglob nullglob # include hidden files
        mv -n tmp_app/* ./ # move all the files, without overwriting
        rm tmp_app -r # delete the folder

        # initialize a git project
        if [ ! -d .git/ ]; then
            git init
            echo "==> You should now run 'git remote add origin URL'"
        fi
    fi
fi

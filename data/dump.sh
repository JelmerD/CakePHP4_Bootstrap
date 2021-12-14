#!/usr/bin/env bash

# this file creates and recovers sql dump files

#########################################################################
# WARNING                                                               #
#                                                                       #
# ONLY USE ON VAGRANT MACHINE                                           #
# ONLY USE FOR TABLES THAT WE ACTUALLY NEED FOR OUR VAGRANT SETUP       #
#   meaning: do not do this on the users table for example              #
#########################################################################

#   USAGE examples
#   cd /var/www
#   bash data/dump dump               - dumps all tables into their corresponding .sql files (without CREATE, use bin/cake migrations for that)
#   bash data/dump dump [table]       - dump a specific table
#   bash data/dump recover            - recovers all tables, as long as that .sql file exists (without CREATE, use bin/cake migrations for that)
#   bash data/dump recover [table]    - recover a specific table

# Name of the database to use
DATABASE="cake_project"

# Path of this file on the vagrant machine
# by hardcoding this, it is impossible to run this on the live machine
DIRPATH="/var/www/data/"

# Tables to include in the dump|recover all option
tables=("")

# show the 'help' page
_showHelp() {
    echo "To use command: database <command> [table]"
    echo "     command: dump|recover"
    echo "     table, optional: one of the tables or available .sql files, depending on command"
    exit 1
}

# if no parameters are given
if [ $# -eq 0 ]; then
    _showHelp
fi

# perform dump function
_performDump() {
    TABLE="$1"
    echo "Dumping ${DATABASE}.${TABLE}"
    mysqldump -uroot -proot ${DATABASE} ${TABLE} --no-create-info >${DIRPATH}${TABLE}.sql
}

#perform recover function
_performRecover() {
    TABLE="$1"
    if [[ -f ${DIRPATH}${TABLE}.sql ]]; then
        echo "Recovering ${DATABASE}.${TABLE}"
        mysql -uroot -proot -D${DATABASE} -e "TRUNCATE table ${TABLE};"
        mysql -uroot -proot ${DATABASE} <${DIRPATH}${TABLE}.sql
    else
        echo "${TABLE}.sql does not exists in ${DIRPATH}"; exit 1
    fi

}

# 'switch' that takes the two commands

# DUMP
if [[ $1 = "dump" ]]; then
    # if no 2nd param is given, perform command on the tables array
    if [[ -z $2 ]]; then
        for t in "${tables[@]}"; do
            _performDump "$t"
        done
    else
        _performDump "$2"
    fi

# RECOVER
elif [[ $1 = "recover" ]]; then
    # if no 2nd param is given, perform command on the tables array
    if [[ -z $2 ]]; then
        for t in "${tables[@]}"; do
            _performRecover "$t"
        done
    else
        _performRecover "$2"
    fi

# If a non-existing command is given, show the help
else
    _showHelp
fi

echo "- Done -"
exit

#!/bin/bash

if [ "$(hostname)" == "xpd1" ]; then
    mariadb -e "SET GLOBAL sql_mode = '';"
    mariadb -e "GRANT ALL ON *.* TO 'importuser'@'%' IDENTIFIED BY 'importuserpasswd';"
    printf "Inserting into Xpand...\n"

else
    echo "This must be run on xpd1!"
    exit 1
fi
#!/bin/bash
#by Chrisitan Gubesch
#last updated 3/7/2018

function install_wordpress {
    cd "${1}"
    wget https://wordpress.org/latest.tar.gz
    tar xzf latest.tar.gz
    cp -R wordpress/* .
    chown -R www-data:www-data .
    PASSWDDB="$(openssl rand -base64 12)"
    echo -n "Enter database name: "
    read MAINDB
    echo -n "Please enter root user MySQL password:"
    read -s rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB} DEFAULT CHARACTER SET utf8;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

    rm latest.tar.gz
    rm -rf wordpress

    ipADDRESS="$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')"

    echo -e "All your wordpress content is now saved at ${1} !\n"
    echo "Now go to your browser and open: ${ipADDRESS}"
    echo "Your database name is: ${MAINDB}"
    echo "Your database User-Name is: ${MAINDB}"
    echo "Your password is: ${PASSWDDB}"
}


echo "Welcome to wordpress installation!"
echo -n "Please enter your wished installation destination: "
read destination
echo ""

if [ -d ${destination} ] ; then
    install_wordpress "${destination}"
else
    echo "${destination} doesn't exist"
    echo -n "do you want to create this folder? (Y/n)"
    read election
    if [ "${election}" == "y" ] || [ "${election}" == "Y" ] || [ "${election}" == "" ] ; then
        mkdir -p "${destination}"
        install_wordpress "${destination}"
    else
        echo -e "\nclosing script"
    fi
    
fi

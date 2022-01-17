#!/bin/bash
#this script will output the short list of server's services status only

NGINX='nginx.service'
HTTPD='httpd.service'
FTPD='pure-ftpd.service'
PHP80='php80-php-fpm.service'
MYSQLD='mysqld.service'

GREEN="\e[1;32m" # \e = escape, [1 = bald text, ;32 = color ANSII decoding, m = finish the escape
RED="\e[1;31m"
NC="\e[0m" #just no color

#This one checks Active status of a service, adds its name to the output and highlights it with the needed color 
check (){
    SERVICE=$1
    ISACTIVE=$(systemctl is-active $SERVICE)
    if [[ $ISACTIVE = 'active' ]]
    then
        COLOR="$GREEN"
    else
        COLOR="$RED"
    fi
    echo -ne "${NC}$SERVICE: "
    echo -e "${COLOR}$ISACTIVE${NC}"
}

check $NGINX
check $HTTPD
check $FTPD
check $PHP80
check $MYSQLD
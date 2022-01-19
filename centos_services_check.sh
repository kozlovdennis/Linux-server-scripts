#!/bin/bash
#when run without values this script will output 
#This script outputs any of one or more processes status (i.e. active) if provided with such values

#Reading the input of services names and stashing it into the array
SERVICES=("$@")
#In case userd didn't enter the services, script will have static server's services that'll be used by default
DEFAULTSERVICES=( nginx httpd mysqld php80-php-fpm pure-ftpd )

GREEN="\e[1;32m" # \e = escape, [1 = bold text, ;32 = green color ANSII decoding, m = finish the escape
RED="\e[1;31m"
NC="\e[0m" #just no color

#This one checks Active status of a service, adds its name to the output and highlights it with the needed color 
function check (){
    SERVICE=$1
    SERVICE="${SERVICE}.service"
    STATUS=$(systemctl is-active $SERVICE) #appending '.service' extention to each service, comment out if excessive
    if [[ $STATUS = 'active' ]]; then
        COLOR="$GREEN"
    else
        COLOR="$RED"
    fi
    echo -ne "${NC}$SERVICE: "
    echo -e "${COLOR}$STATUS${NC}"
}

#Initiate cycling through services within the array and for each of them run check function
function init (){
    ARRAY=("$@") #Taking all the array values passed to this function into a single variable
    for i in "${ARRAY[@]}"; do
        check $i #running the check funcion for each service name (variables in the array)
    done
}

#If the SERVICES array will contain something, preceed with its values, or else assign to it static values
if [[ ${#SERVICES[@]} -eq 0 ]]; then
    init "${DEFAULTSERVICES[@]}"
else
    init "${SERVICES[@]}"
fi

#Clearing the environmental variable after usage
SERVICES=()
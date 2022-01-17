#!/bin/bash

GREEN="\e[1;32m" # \e = escape, [1 = bald text, ;32 = color ANSII decoding, m = finish the escape
NC="\e[0m" #just no color

NGINX=$(systemctl is-active nginx.service)
echo -ne "${NC}nginx.service: "
echo -e "${GREEN}$NGINX${NC}"

HTTPD=$(systemctl is-active httpd.service)
echo -ne "${NC}httpd.service: "
echo -e "${GREEN}$HTTPD${NC}"

FTPD=$(systemctl is-active pure-ftpd.service)
echo -ne "${NC}pure-ftpd.service: "
echo -e "${GREEN}$FTPD${NC}"

PHP80=$(systemctl is-active php80-php-fpm.service)
echo -ne "${NC}php80-php-fpm.service: "
echo -e "${GREEN}$PHP80${NC}"

MYSQLD=$(systemctl is-active mysqld.service)
echo -ne "${NC}mysqld.service: "
echo -e "${GREEN}$MYSQLD${NC}"
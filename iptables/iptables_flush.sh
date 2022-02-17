#!/bin/zsh
#this script flushes the iptables to ACCEPT
IPTABLES=/sbin/iptables
POLICY=$1 # policy setting

function checkinput(){
    if [[ $1 != 'active' ]]; then
        COLOR="$GREEN"
    else
        COLOR="$RED"
    fi
}

### flush existing rules and set chain policy setting
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

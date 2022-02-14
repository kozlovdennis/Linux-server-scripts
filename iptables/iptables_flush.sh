#!/bin/zsh
#this script flushes the iptables to ACCEPT
IPTABLES=/sbin/iptables

### flush existing rules and set chain policy setting to ACCEPT
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

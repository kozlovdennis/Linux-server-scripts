#!/bin/bash
# this script configures the iptables using ACCPT as default policy, as a result this is a simpler way to configure iptables
IPTABLES=/usr/sbin/iptables # which iptables
MODPROBE=/usr/sbin/modprobe # which modprobe
INT_NET="10.12.101.0/24" # ip addr show
INT_NIC=enp0s8 # default router name: (to find use "arp -vn" command (you need to install net-tools for that first))
SSH_IP="10.12.100.14" # an ip address that SSH connection is allowed from
SSH_NIC=enp0s5

#Flush to accept (Permit all)
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

### state tracking rules
$IPTABLES -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A INPUT -p icmp -j ACCEPT
$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
$IPTABLES -A INPUT -j REJECT --reject-with icmp-host-prohibited
$IPTABLES -A FORWARD -j REJECT --reject-with icmp-host-prohibited

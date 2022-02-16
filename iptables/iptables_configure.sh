#!/bin/bash
# this script configures the iptables
IPTABLES=/usr/sbin/iptables # which iptables
MODPROBE=/usr/sbin/modprobe # which modprobe
INT_NET="10.12.101.0/24" # ip addr show
INT_NIC=enp0s8 # default router name: (to find use "arp -vn" command (you need to install net-tools for that first))
SSH_IP="10.12.100.14" # network that SSH connection is allowed from
SSH_NIC=enp5s0

### flush existing rules and set chain policy setting to DROP:
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F
$IPTABLES -F -t nat
$IPTABLES -X
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

### load connection-tracking modules
$MODPROBE ip_conntrack
$MODPROBE iptable_nat
$MODPROBE ip_conntrack_ftp
$MODPROBE ip_nat_ftp

### INPUT chain ###
echo "[+] Setting up INPUT chain..."

### state tracking rules
$IPTABLES -A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A INPUT -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

### anti-spoofing rules
$IPTABLES -A INPUT -i $INT_NIC ! -s $INT_NET -j LOG --log-prefix "SPOOFED PKT "
$IPTABLES -A INPUT -i $INT_NIC ! -s $INT_NET -j DROP

### ACCEPT rules
$IPTABLES -A INPUT -i $INT_NIC -s $INT_NET -p tcp --syn -m conntrack --ctstate NEW --dport 22 -j ACCEPT
$IPTABLES -A INPUT -i $SSH_NIC -s $SSH_IP -p tcp --syn -m conntrack --ctstate NEW --dport 22 -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

### default INPUT LOG rule
$IPTABLES -A INPUT ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options

### OUTPUT chain ###
echo "[+] Setting up OUTPUT chain..."

### state tracking rules
$IPTABLES -A OUTPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A OUTPUT -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

### ACCEPT rules for allowing connections out
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 21 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 22 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 25 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 43 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 80 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 443 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 4321 -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --syn -m conntrack --ctstate NEW --dport 53 -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

### default OUTPUT LOG rule
$IPTABLES -A OUTPUT ! -o lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options


### FORWARD chain ###
echo "[+] Setting up FORWARD chain..."

### state tracking rules
$IPTABLES -A FORWARD -m conntrack --ctstate INVALID -j LOG --log-prefix "DROP INVALID " --log-ip-options --log-tcp-options
$IPTABLES -A FORWARD -m conntrack --ctstate INVALID -j DROP
$IPTABLES -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

### anti-spoofing rules
$IPTABLES -A FORWARD -i $INT_NIC ! -s $INT_NET -j LOG --log-prefix "SPOOFED PKT "
$IPTABLES -A FORWARD -i $INT_NIC ! -s $INT_NET -j DROP

### ACCEPT rules
$IPTABLES -A FORWARD -i $INT_NIC -s $INT_NET -p tcp --syn -m conntrack --ctstate NEW --dport 21 -j ACCEPT
$IPTABLES -A FORWARD -i $INT_NIC -s $INT_NET -p tcp --syn -m conntrack --ctstate NEW --dport 22 -j ACCEPT
$IPTABLES -A FORWARD -i $INT_NIC -s $INT_NET -p tcp --syn -m conntrack --ctstate NEW --dport 25 -j ACCEPT
$IPTABLES -A FORWARD -i $INT_NIC -s $INT_NET -p tcp --syn -m conntrack --ctstate NEW --dport 43 -j ACCEPT
$IPTABLES -A FORWARD -p tcp --syn -m conntrack --ctstate NEW --dport 80 -j ACCEPT
$IPTABLES -A FORWARD -p tcp --syn -m conntrack --ctstate NEW --dport 443 -j ACCEPT
$IPTABLES -A FORWARD -i $INT_NIC -s $INT_NET -p tcp --syn -m conntrack --ctstate NEW --dport 4321 -j ACCEPT
$IPTABLES -A FORWARD -p udp -m conntrack --ctstate NEW --dport 53 -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT

### default log rule
$IPTABLES -A FORWARD ! -i lo -j LOG --log-prefix "DROP " --log-ip-options --log-tcp-options

### NAT rules ###
#

### forwarding ###
echo "[+] Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward
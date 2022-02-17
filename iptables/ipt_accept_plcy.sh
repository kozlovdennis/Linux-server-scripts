#!/bin/bash
# this script configures the iptables using ACCPT as default policy, as a result this is a simpler way to configure iptables
IPTABLES=/usr/sbin/iptables # which iptables
MODPROBE=/usr/sbin/modprobe # which modprobe
INT_NET="10.12.101.0/24" # ip addr show
INT_NIC=enp0s8 # default router name: (to find use "arp -vn" command (you need to install net-tools for that first))
SSH_IP="10.12.100.14" # an ip address that SSH connection is allowed from
SSH_NIC=enp0s5
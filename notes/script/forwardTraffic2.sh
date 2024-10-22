#!/bin/bash

IPTABLES=/sbin/iptables

#WANIF='enx6c3c8cf7f3b6'
WANIF='wlp0s20f3'
#LANIF='enxc025a55823f0'
#LANIF='enx6c3c8cf7f3b6'
#LANIF='eth0'
LANIF='br0'
#LANIF='incusbr0'

# Enable IP forwarding in the kernel
echo 'Enabling Kernel IP forwarding...'
/bin/echo 1 > /proc/sys/net/ipv4/ip_forward

# Docker rules
$IPTABLES -I DOCKER-USER -i incusbr0 -j ACCEPT
$IPTABLES -I DOCKER-USER -o incusbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Flush rules and delete chains
echo 'Flushing rules and deleting existing chains...'
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -t nat -F
$IPTABLES -t nat -X
$IPTABLES -t mangle -F
$IPTABLES -t mangle -X
$IPTABLES -F
$IPTABLES -X

# Enable masquerading to allow LAN internet access
echo 'Enabling IP Masquerading and other rules...'
$IPTABLES -t nat -A POSTROUTING -o $WANIF -j MASQUERADE
$IPTABLES -A FORWARD -i $LANIF -o $WANIF -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A FORWARD -i $WANIF -o $LANIF -j ACCEPT

# Allow DNS traffic between LAN and WAN
#$IPTABLES -A FORWARD -i $LANIF -o $WANIF -p udp --dport 53 -j ACCEPT
#$IPTABLES -A FORWARD -i $WANIF -o $LANIF -p udp --sport 53 -j ACCEPT
#$IPTABLES -A FORWARD -i $LANIF -o $WANIF -p tcp --dport 53 -j ACCEPT
#$IPTABLES -A FORWARD -i $WANIF -o $LANIF -p tcp --sport 53 -j ACCEPT

# Enable DNS NAT for the LAN interface
#$IPTABLES -t nat -A POSTROUTING -o $LANIF -p udp --dport 53 -j MASQUERADE
#$IPTABLES -t nat -A POSTROUTING -o $LANIF -p tcp --dport 53 -j MASQUERADE

echo 'Done. To finish, ensure DNS server IP is reachable and correctly configured in the container.'


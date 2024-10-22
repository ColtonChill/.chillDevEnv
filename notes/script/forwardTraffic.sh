#!/bin/bash

IPTABLES=/sbin/iptables

# WANIF='eth0'
WANIF='wlp0s20f3'
#LANIF='enxc025a55823f0'
#LANIF='eth0'
#LANIF='lxdbr0'
#LANIF='contbr0'
LANIF='br0'

# enable ip forwarding in the kernel
echo 'Enabling Kernel IP forwarding...'
/bin/echo 1 > /proc/sys/net/ipv4/ip_forward

echo 'Flushing existing iptables rules...'
$IPTABLES -F
$IPTABLES -t nat -F
$IPTABLES -X

# (Re-enable all traffic) Set default policies to ACCEPT
echo 'Setting default policies to ACCEPT...'
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT ACCEPT

# Set up NAT (Masquerading) on the WAN interface only
echo 'Setting up NAT on the WAN interface...'
$IPTABLES -t nat -A POSTROUTING -o $WANIF -j MASQUERADE

# Allow forwarding from LAN to WAN
echo 'Allowing forwarding from LAN to WAN...'
$IPTABLES -A FORWARD -i $LANIF -o $WANIF -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Allow forwarding for established and related connections from WAN to LAN
echo 'Allowing forwarding from WAN to LAN...'
$IPTABLES -A FORWARD -i $WANIF -o $LANIF -m state --state ESTABLISHED,RELATED -j ACCEPT

echo 'Allowing DNS traffic from LAN to WAN...'
$IPTABLES -A FORWARD -i $LANIF -o $WANIF -p udp --dport 53 -j ACCEPT
$IPTABLES -A FORWARD -i $LANIF -o $WANIF -p tcp --dport 53 -j ACCEPT


# # flush rules and delete chains
# echo 'Flushing rules and deleting existing chains...'
# $IPTABLES -F
# $IPTABLES -X
# 
# # enable masquerading to allow LAN internet access
# echo 'Enabling IP Masquerading and other rules...'
# $IPTABLES -t nat -A POSTROUTING -o $LANIF -j MASQUERADE
# $IPTABLES -A FORWARD -i $LANIF -o $WANIF -m state --state RELATED,ESTABLISHED -j ACCEPT
# $IPTABLES -A FORWARD -i $WANIF -o $LANIF -j ACCEPT
# 
# $IPTABLES -t nat -A POSTROUTING -o $WANIF -j MASQUERADE
# $IPTABLES -A FORWARD -i $WANIF -o $LANIF -m state --state RELATED,ESTABLISHED -j ACCEPT
# $IPTABLES -A FORWARD -i $LANIF -o $WANIF -j ACCEPT
# 
# echo 'Done. To finish, enter the following on the target:'
# echo 'ip route add default via <host> dev <dev>'

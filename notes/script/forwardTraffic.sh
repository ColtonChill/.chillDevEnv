#!/bin/bash

IPTABLES=/sbin/iptables

WANIF='enx6c3c8cf7f3b6'
#WANIF='wlp0s20f3'
#LANIF='enxc025a55823f0'
#LANIF='eth0'
#LANIF='lxdbr0'
#LANIF='enx6c3c8cf7f3b6'
#LANIF='br-1'
LANIF='incusbr0'

# enable ip forwarding in the kernel
echo 'Enabling Kernel IP forwarding...'
/bin/echo 1 > /proc/sys/net/ipv4/ip_forward

# flush rules and delete chains
echo 'Flushing rules and deleting existing chains...'
$IPTABLES -F
$IPTABLES -X

# enable masquerading to allow LAN internet access
echo 'Enabling IP Masquerading and other rules...'
$IPTABLES -t nat -A POSTROUTING -o $LANIF -j MASQUERADE
$IPTABLES -A FORWARD -i $LANIF -o $WANIF -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A FORWARD -i $WANIF -o $LANIF -j ACCEPT

$IPTABLES -t nat -A POSTROUTING -o $WANIF -j MASQUERADE
$IPTABLES -A FORWARD -i $WANIF -o $LANIF -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -A FORWARD -i $LANIF -o $WANIF -j ACCEPT

echo 'Done. To finish, enter the following on the target:'
echo 'ip route add default via <host> dev <dev>'

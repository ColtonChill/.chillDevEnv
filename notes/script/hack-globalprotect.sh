#!/bin/bash

### Incus
sudo ip route add 10.137.134.0/24 dev incusbr0 src 10.137.134.1 table 200
sudo ip rule add to 10.137.134.0/24 lookup 200 priority 100

### LAN
# Add a LAN route to table 200 
sudo ip route add 192.168.1.0/24 dev wlp0s20f3 src 192.168.1.163 table 200
# Add a rule with a different priority than above Incus rule (100)
sudo ip rule add to 192.168.1.0/24 lookup 200 priority 101

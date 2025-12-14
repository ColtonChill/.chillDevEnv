## IP command

### Persistant IP
```
nmcli con add type ethernet ifname eth1 con-name eth1 autoconnect yes ipv4.address 192.168.0.222/24 ipv4.method manual
```

## brctl
```
brctl addbr <bridgeName>
brctl addif <bridgeName> <dev>
```

### setting up a bridge (temporary)
```
ip link add name <bridge> type bridge
ip link set <dev> master <bridge>
  * undo: ip link set ens18 nomaster
ip link set <dev> up
ip link set <bridge> up
ip a add 192.168.0.234/24 dev <bridge>
```
### Persistant bridge
```
nmcli con add type bridge con-name br0 ifname br0 \
    ipv4.method manual ipv6.method ignore ipv4.address 192.168.0.234/24 bridge.stp yes
nmcli con add type ethernet slave-type bridge ifname eth1 master br0
```

## ip route
How to set up a routed ip (TMX)
```
sudo ip r add 172.24.244.0/24 via 172.24.220.1
```

[link](https://www.zenarmor.com/docs/linux-tutorials/how-to-configure-network-bridge-on-linux)


## Set up bridge on Host
nmcli con add type bridge con-name br0 ifname br0 \
    ipv4.method manual ipv6.method ignore ipv4.address 192.168.0.234/24 bridge.stp no
nmcli con add type bridge-slave con-name br0-slave ifname <dev> master br0
nmcli connection up br0-slave
nmcli connection up br0


## Set/Change default bridge IP range
```
incus network set incusbr0 ipv4.address 192.168.0.1/24
```

### Set bridge profile
incus profile device add br0-profile eth1 nic nictype=bridge parent=br0 name=eth1
incus profile add deb1 br0-profile 

### Set up bridge connection
incus config device add <container> eth1 nic nictype=bridged parent=br0

### Set up shared disk
incus config device add <container> sigma disk path=/root/shared/sigma source='/home/chill/work/sigma'
incus config set <container> security.privileged true
incus config set <container> security.nesting true

### For Nesting containers
incus config set <container> security.nesting true
incus config set <container> raw.lxc "
lxc.apparmor.profile = unconfined
lxc.cgroup.devices.allow = a
lxc.mount.auto = cgroup:rw
lxc.cap.drop =
"


#### Remove the share
incus config device remove rockyJenkins shared

## Set up bridge on Host
nmcli con add type bridge con-name br0 ifname br0 \
    ipv4.method manual ipv6.method ignore ipv4.address 192.168.0.234/24 bridge.stp yes
nmcli con add type bridge-slave con-name br0-slave ifname <dev> master br0
nmcli connection up br0-slave
nmcli connection up br0


## Set/Change default bridge IP range
```
incus network set incusbr0 ipv4.address 192.168.0.1/24

# For allowing containers work on the vpn
    incus network set incusbr0 dns.nameservers="172.31.35.2"
    incus network set incusbr0 dns.search="sdl.usu.edu usurf.usu.edu"

    incus network unset incusbr0 dns.nameservers
    incus network unset incusbr0 dns.search
```


### Set bridge profile
```
incus profile device add br0-profile eth1 nic nictype=bridge parent=br0 name=eth1
incus profile add deb1 br0-profile 
```

### Set up bridge connection
```bash
incus config device add <container> eth1 nic nictype=bridged parent=br0
# in container
nmcli connection add type ethernet con-name host-br0 ifname eth1 autoconnect yes ipv4.addresses 192.168.0.222/24 ipv4.method manual
```

### Set up shared disk
```bash
incus config device add <container> sigma_src disk path=/root/shared/sigma source='/home/chill/work/sigma'
incus config set <container> security.privileged true
incus config set <container> security.nesting true
# if rocky9
incus config set <container> raw.lxc 'lxc.apparmor.profile=unconfined'
incus config set <container> security.apparmor.unconfined true
```


### For Nesting containers
```bash
incus config set <container> security.nesting true
incus config set <container> raw.lxc "
lxc.apparmor.profile = unconfined
lxc.cgroup.devices.allow = a
lxc.mount.auto = cgroup:rw
lxc.cap.drop =
"
```

#### Remove the share
incus config device remove rockyJenkins shared

### Export container to remote server
```bash
incus copy <container> remote:<container>
```

## Share a GPU with container (for CUDA)
1. Install NVidia drivers on the host
  2. Insure it's working
      ```bash
      nvidia-smi
      ```
3. Add GPU
    ```bash
    incus config device add <container> gpu gpu
    incus restart <container>
    ```
4. Enable nvidia runtime
    ```bash
    incus config set <container> security.privileged false
    incus config set <container> nvidia.runtime=true
    ```

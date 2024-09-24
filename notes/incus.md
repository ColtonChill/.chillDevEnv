incus config device add <name of container> <name of device>(tak connector) proxy listen=tcp:0.0.0.0:port
incus config device add <name of container> <name of device>(tak connector) proxy connect=tcp:0.0.0.0:port

incus config device add my-container eth0 nic name=eht0 nictype=bridged parent=lxdbr0
* Don't think this works
* --> incus config device set my-container eth0 ipv4.address 10.15.78.100

### Set static IP (incus managed brige)
incus config device override [container-name] eth0
incus config device set [container-name] eth0 ipv4.address=192.168.0.201


### (old) set static ip of containers
incus profile create static-ip-debX
incus profile device add static-ip-debX eth0 nic nictype=bridged parent=incusbr0 ipv4.address=192.168.10.20X
incus profile device add static-ip-debX root disk path=/ pool=default
incus profile assign debX static-ip-debX

### Set bridge profile
incus profile device add br0-profile eth1 nic nictype=bridge parent=br0 name=eth1
incus profile add deb1 br0-profile 

### Set up shared disk
incus config device add rockyJenkins shared disk path=/root/shared source='/home/chill/work/sigma'
incus config set rockyJenkins security.privileged true


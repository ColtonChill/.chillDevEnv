### Networking
#### IP Tables Visualizer
sudo iptables -t nat -L -n -v

#### Get IS2OPS vpn ip
```
sudo ip addr add 192.168.38.234/24 dev enxf8e43bc74c8e'
```
### Virtual Machine
Guide: [Link](https://www.tecmint.com/install-qemu-kvm-ubuntu-create-virtual-machines/)
```
$ virt-manager

$ sudo virsh net-list --all
$ sudo virsh net-start default
$ sudo virsh net-autostart default
```

###  Flashing jetson via ./flash.sh
#### Kraven copying
```
sudo ./flash.sh -r -k APP -G KRAVEN.img jetson-xavier mmcblkop1
```
*Rudi modification*
```
jetson-xavier-nx-devkit-emmc nvme0n1
```



### Segmentation parameters
pip install nettron 8080

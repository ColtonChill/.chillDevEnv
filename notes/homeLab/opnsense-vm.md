# Set up router from scratch

## Install dependencies
```bash
# vm install
sudo apt install qemu-utils qemu-system-x86
# vm viewer
sudo apt install spice-client-gtk
```


## Import router `.iso` as a VM

### Download and unzip compressed `.iso`
```bash
bzip2 -d OPNsense-dvd-amd64.iso.bz2
```

### Initialize an empty VM
```bash
incus init opnSense-vm --empty --vm -c limits.cpu=2 -c limits.memory=8GiB -d root,size=50GiB
```

### Make a disk volume and attach it to the VM
```bash
incus storage volume import default OPNsense.iso opnSense-volume --type=iso
incus config device add opnSense-vm opnSense-volume disk pool=default source=opnSense-volume boot.priority=10
```

### Disable secure boot
```bash
incus config set opnSense-vm security.secureboot=false
```
### Set VM to start on host boot up
```bash
incus config set opnSense-vm boot.autostart true
```

### Log in and test OS
```bash
incus start opnSense-vm # (optional) --console
incus console opnSense-vm --type vga
```


## Set up OS networking

### Create fresh profile to remove incusbr0
```bash
incus profile create router
incus profile edit router
# config: {}
# description: router profile
# devices:
#   root:
#     path: /
#     pool: zfs-incus
#     type: disk
# name: router
# used_by: []

incus profile assign opnSense-vm router
```

### Set up network interfaces

#### Figure out host interfaces to use as LAN/WAN
```bash
ip -br -c a
# or
nmcli d
# Example:
# --- enp4s0f0 (modem/WAN)
# --- enp4s0f1 (switch/LAN)
```
#### Allocate interfaces
```bash
# WAN
incus config device add opnSense-vm eth-wan nic \
  nictype=macvlan \
  parent=enp4s0f0

# LAN (create managed incus bridge for lan interface)
incus network create br-lan --type=bridge \
  ipv4.address=none \
  ipv6.address=none
incus config device add opnSense-vm eth-lan nic network=br-lan
incus network set br-lan bridge.external_interfaces=enp4s0f1

#### Pin mac addresses for all these devices
incus config device set opnSense-vm eth-wan  hwaddr=00:16:3e:aa:bb:01
incus config device set opnSense-vm eth-lan  hwaddr=00:16:3e:aa:bb:02
```


## OpnSense Configurations

### Setup interface mapping
```bash
incus start opnSense-vm
incus console opnSense-vm --type vga
```
1. Login and set new password
2. Select option "1) Assign interfaces"
  * Decline configuring LAGGs & VLANs
  * Fill in the rest according your notes

### To the Web GUI
1. Update router software
  * System -> Firmware -> Plugins -> Status
  * Will likely need to restart the router
2. System -> Firmware -> Plugins: check "Show community plugins"
3. Install `os-caddy` and some theme you like

### Static IP Addresses
* Services -> Dnsmasq DNS & DHCP -> Leases
* Pin any mac address to ip's you'd like
* Add a range of addresses to handout via DHCP
  * Interface = LAN
  * Consider deleting any default ranges


### Caddy
* Remap Web GUI port
  * System -> Settings -> Administration: 8443
  * Check "Disable web GUI redirect rule"
* Frewall rules
  * Firewall -> Rules -> WAN
    * Add rule (HTTP):
      * interface = WAN
      * TCP/IP Version = IPv4+IPv6
      * Protocol = TCP
      * Source = Any
      * Destination = This Firewall
      * Destination port range = from "HTTP" to "HTTP"
      * Description = Caddy Reverse Proxy HTTP WAN
    * Add rule (HTTPS):
      * interface = WAN
      * TCP/IP Version = IPv4+IPv6
      * Protocol = TCP/UDP
      * Source = Any
      * Destination = This Firewall
      * Destination port range = from "HTTPS" to "HTTPS"
      * Description = Caddy Reverse Proxy HTTPS WAN
  * Firewall -> Rules -> LAN
    * Copy the WAN rules above
  * Set outbound NAT mode to "Hybrid"
    * Firewall -> NAT -> Outbound: select "Hybrid Outbound NAT"
* Services -> Caddy -> General Settings
  * In the Caddy general tab:
    * Enable Caddy
    * Set ACME email (your own email)
  * DNS provider Tab:
    * DNS Provider = Cloudflare
    * API Key = (Get from cloud flare)
    * Resolvers = 1.1.1.1
    * IP Version = IPv4 only
* Services -> Caddy -> Reverse Proxy
  * Domains:
    * add one root domain
      * protocol = https://
      * domain = *.cchill.org
      * check "DNS-01 Challenge"
      * description = "root domain"
    * add one sub-domain for each service
      * Domain = *.cchill.org
      * Subdomain = example.cchill.org
      * check "Dynamic DNS"
      * description = "example subdomain"
  * Handlers:
    * add one handler per subdomain
      * Domain = https://*.cchill.org
      * Subdomain = example.cchill.org
      * Directive = reverse_proxy
      * Protocol = http://
      * Upstream Domain = IP of service
      * Upstream Port = Port of service
      * description = "example handler"

TODO: figure out NAT hairpinning

### OpenVpn
* port: 1194
* protocol: UDP

* Make a user(s) account to attach certs 
  * System -> Access -> Users: Add
    * Add username & password
* Make a CA (certificate Athority) used for issuing certs for the server and users
  * Make a Root CA
    * System -> Trust -> Authorities: Add
      * Description = "Root OpenVpn CA"
      * Keep the rest of the defaults
  * Issue Leaf Certificate
    * System -> Trust -> Certificates: 
      * Add a sever leaf cert
        * Description = "OpenVpn Server Cert"
        * Type = "Server Certificate"
        * Issuer = "Root OpenVpn CA"
        * Common Name = "OPNsense"
      * Add a client leaf cert
        * Description = "OpenVpn User Cert"
        * Type = "Client Certificate"
        * Issuer = "Root OpenVpn CA"
        * Common Name = "User"
* Generate a VPN static key
  * VPN -> OpenVPN -> Instances -> Static Keys
    * Description = OpenVpn Static Key
    * Mode = auth
    * click gear icon "Generate new key"
* Create a server instance
  * VPN -> OpenVPN -> Instances
    * Description = "OpenVpn Server"
    * Server IPv4 = 10.8.6.0/24 (or any local unused subnet)
    * Certificate = "OpenVpn Server Cert"
    * TLS static key = "OpenVpn Static Key"
    * Authentication = "local database"
    * Local Network = 192.168.1.0/24
* Open Firewall port 1194/UDP
  * Firewall -> Rules -> WAN:
    * Protocol = UDP
    * Destination port range = 1194
  * Firewall -> Rules -> OpenVPN
    * Defaults should be fine
* Export Client Profile
  * VPN -> OpenVPN -> Client Export
    * Export type = File only
    * Host name = vpn.cchill.org
    * Port = 1194

#### MSS clamping
It might be necessary to clamp the mss/mtu for ssh to work right. Add this rull
* Firewall -> Settings -> Normalization
  * Interface = OpenVPN
  * Max mss = 1380


## Add Services Auxiliary Networks
```bash
# Use `incus admin init` to setup default incusbr0
# Set a static subnet for incus services
incus network set incusbr0 ipv4.address '10.10.10.1/24'
# For each container
  # Set a IP address for each service 
  incus config device override [container] eth0 
  incus config device set [container] eth0 ipv4.address 
  incus config set <instance-name> boot.autostart=true
```


# TODO:
* upnp (universal plug & play)
* openvpn
* caddy
  * jellyfin
  * foundryvtt


# Bugs & Foot Guns
### UPNP
TODO:
```
Strict NAT detected. No UPnP orNAT-PMP detected.
Please forward UDP ports 4950 & 4955 to 192.168.1.100
```
* Services -> UPnP IGD & PCP -> Settings
  * Check "Enable"
  * Check "Allow UPnP IGD Port Mapping"
  * Set external interface to WAN and internal to LAN
  * Un-check "Default deny"
  * Set ACL entry 1 "allow 4950-4955 192.168.1.100/32 4950-4955"


### Disconnect the iso device at some point
```
incus config device remove opnSense-vm opnSense-volume
```

### VM not getting the modem's public IP?
Tell the network manager to knock it off.
```
nmcli dev disconnect enp4s0f0
nmcli dev set enp4s0f0 managed no
```
Restart both the modem and the vm.

### Add raw.qemu settings to incus config
```
# incus config show opnSense-vm
  raw.qemu: |
    -cpu host
  raw.qemu.conf: |
    [device "dev-qemu_rng"]
```

### Fix Clock drift for TLS
```
incus config set opnSense-vm security.time.offset=0
```
Enable NTP
Point it at external servers, not the host



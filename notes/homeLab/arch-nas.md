# Setup for the arch machine
[installation guide](https://wiki.archlinux.org/title/Installation_guide)

## Revert kernel to long term version rather then bleeding edge
```bash
sudo pacman -S linux-lts linux-lts-headers
```

## Boot-loader (systemd-boot)
```bash
vim /boot/loader/entries/arch.conf
"""
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=XXXX rw
"""
vim /boot/loader/entries/arch-lts.conf
"""
title   Arch Linux LTS
linux   /vmlinuz-linux-lts
initrd  /initramfs-linux-lts.img
options root=UUID=XXXX rw
"""
vim /boot/loader/loader.conf
"""
default arch-lts.conf
timeout 4
console-mode max
"""
```


## Networking
Swap out `systemd-networkd` with `networkmanager`
```bash
# Install network manager
pacman -S networkmanager
# Disable networkd
systemctl disable --now systemd-networkd
systemctl status systemd-networkd
# Turn on network manager
systemctl enable --now NetworkManager
nmcli device status
# Insure resolved
resolvectl status
systemctl status systemd-resolved
systemctl enable --now systemd-resolved
```

## Set up non-root user


## Update Pacman
```
pacman -Syyu
```



## Desktop
### Desktop manager?:
Install Desktop manager(plasma-meta) & Display Manager(sddm)
```bash
pacman -S plasma-meta
pacman -S sddm
```




## RAID drive mounding
Philosophy: 
- Hierarchy goes: Disks → vdevs → pool → datasets
- Incus only touches the datasets

### Install ZFS & Incus 
```bash
# Add the zfs repo
vim /etc/pacman.d/archzfs
"""
[archzfs]
SigLevel = Never
Server = https://archzfs.com/$repo/x86_64
"""
# Enable the zfs repo
vim /etc/pacman.conf
"""
Include = /etc/pacman.d/archzfs
"""
# Install & enable zfs
sudo pacman -S zfs-dkms
sudo systemctl enable zfs-import-cache # imports pools in /etc/zfs/zpools.cache
sudo systemctl enable zfs-mount  # mount
sudo systemctl enable zfs-zed # zfs event daemon
# Install incus
sudo pacman -S incus
sudo systemctl enable --now incus.socket
# Delicate incus permissions to user
sudo usermod -aG incus-admin [user]
# Set range of sub(u,g)ids for the root user
sudo usermod -v 1000000-1000999999 -w 1000000-1000999999 root
```

### Set up zfs pool
```bash
# Get disk IDs for pool(tank) creation
# Don't use sdx, they drift
ls -l /dev/disk/by-id/
# Create the zfs pool
sudo zpool create tank raidz2 \
    /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN1338P4H8590B \
    /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN1334PBHRU59P \
    /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN1334PBHST4EP \
    /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN2331PAKBX65T
# verify
zpool status
# import automatically
sudo zpool set cachefile=/etc/zfs/zpool.cache tank
```

#### Optional extras
```bash
# Compression
sudo zfs set compression=lz4 tank
# turn off "on read" file update events
sudo zfs set atime=off tank
# Schedule Monthly
??? sudo zpool scrub tank
??? systemctl enable zfs-scrub-monthly@otherpool.timer --now
```

## Set up Incus services
### Dataset hierarchy
```
tank
├── incus/                 # Official Incus storage pool — let Incus manage everything here
│   ├── containers/
│   ├── images/
│   └── custom/            # Where nextcloud-data, jellyfin-config, vaultwarden-data, etc, live automatically
│
├── media/                 # The shared library (this is the only thing that really needs to be "shared")
│   ├── movies/
│   ├── tv/
│   ├── photos/
│   └── ...                # Organize however you want
│
└── backups/               # For zfs send | incus export or rsync
```

### Set up zfs dataset for incus
```bash
# Create default incus dataset
zfs create -o recordsize=128k \
           -o mountpoint=/tank/incus \  # needed by incus
           tank/incus
# Tell incus about the dataset
incus storage create zfs-incus zfs source=tank/incus

# Create shared datasets (nextcloud, jellyfin)
zfs create -o compression=off \
           -o atime=off -o recordsize=1M \
           tank/media
zfs set mountpoint=/tank/media tank/media   # or wherever on host
```
### Example of how to set up new service
```
# Create Incus custom volumes for app data
incus storage volume create default [volume-name]
# ... repeat for jellyfin-data, foundryvtt-data, vaultwarden-data, etc.
```


### Create shared datasets (nextcloud, jellyfin)
```bash
```
# Spin up new contain in zpool (example debian)
incus launch images:debian/13 [my-container] zfs-incus

### ZFS snapshots
```bash
zfs snapshot -r tank@daily
```

//////////////////////////////////////
////////// Work in progress //////////
//////////////////////////////////////


# Questions to answer
- `zfs snapshot -r tank@daily`
  ```
  zfs snapshot tank/incus@pre-upgrade
  zfs snapshot tank/services/nextcloud/data@daily
  ```
* Define snapshot schedules
* Design replication/off-host backup
* Tune ARC/L2ARC for your RAM
* Or wire Incus profiles → datasets cleanly

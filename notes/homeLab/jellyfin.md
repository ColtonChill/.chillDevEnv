# Setting up Jellyfin Services

## Setup container
```bash
# Create Incus custom volumes for app data
incus storage volume create zfs-incus jellyfin-config
# Launch base image
incus launch images:debian/13 jellyfin --storage zfs-incus
# Set a IP address for each service 
incus config device override jellyfin eth0
incus config device set jellyfin eth0 ipv4.address 10.10.10.102
incus config device add jellyfin 8096-proxy proxy \
    listen=tcp:0.0.0.0:8096 \
    connect=tcp:127.0.0.1:8096
# Elevate container for read permission
incus config set jellyfin security.privileged true
# Make container start automatically
incus config set jellyfin boot.autostart=true
```

### Attach incus volumes to the Jellyfin container
```bash
# Incus-managed volumes (snapshottable with Incus)
incus config device add jellyfin jellyfin-config disk \
    pool=zfs-incus \
    source=jellyfin-config \
    path=/var/lib/jellyfin
# Shared media (external ZFS bind)
incus config device add jellyfin media disk \
    source=/tank/media \
    path=/mnt/media
# reboot
incus exec jellyfin reboot
```

## Install Jellyfin
```bash
# incus shell jellyfin
apt install curl
curl -s https://repo.jellyfin.org/install-debuntu.sh | sudo bash
```


# Migrate VM to New Host

## Prep New Host

### Prep VM for migration
```bash
# shutdown vm (if not already)
incus stop opnSense-vm
# change storage (see: "incus storage list" on host)
incus profile edit router # set pool: zfs-incus
incus config device set opnSense-vm eth-wan parent=enp6s0f0
```

### Add networking devices to new host
(see (router-vm networking)[./router-vm.md###Set up network inferfaces])
```bash
# Set up lan bridge
incus network create br-lan --type=bridge \
  ipv4.address=none \
  ipv6.address=none
# Slave external interface to br-lan
incus network set br-lan bridge.external_interfaces=enp6s0f1
```

### Prep remote target as server
```bash
# On remote host
incus config set core.https_address :8765
incus config trust add [client-name]
# On client host
incus remote add [my-remote] ip:8765
```

## Migrate VM on Old Host
```bash
# Copy over profile and then the vm
incus profile copy router node:router
incus move opnSense-vm node:opnSense-vm --storage zfs-incus --mode push
```

## Post migration tweaks (firmware)
```bash
# ??? Install full firmware support ???
??? sudo pacman -S qemu-full
# Force incus to regenerate firmware metadata
incus config unset opnSense-vm security.secureboot
incus config set opnSense-vm security.secureboot false
# Verify
sudo pacman -S spice-gtk
incus console opnSense-vm --type vga
```


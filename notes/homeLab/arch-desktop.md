# Setup and Flash Arch Desktop
[installation guide](https://wiki.archlinux.org/title/Installation_guide)

## Pre-Install Setup

### Verify internet
```bash
# set keyboard
loadkeys en
# check internet connection
ip -c link
ip -c -br a
ping ping.archlinux.org
# check system clock
timedatectl
```

### Partition disk
Use UEFI with GPT
```bash
# look at current partition
lsblk # fdisk -l
fdisk /dev/nvme0n1
# delete old ones before making new ones
> d
# create empty GPT partition table
> g
# make new partitions 
# boot
> n last_sector +1G
> t uefi
# swap
> n last_sector +8G
> t swap
# root
> n last_sector remainder
> t linux
# double check & write
> p
> w
```

### Format Partition
```bash
# format boot
mkfs.fat -F 32 /dev/nvme0n1p1
# format swap
mkswap /dev/nvme0n1p2
# format swap
mkfs.ext4 /dev/nvme0n1p3
```

### Mount Partitions
```bash
mount /dev/nvme0n1p3 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
# enable swap partition
swapon /dev/nvme0n1p2
```

## Install Arch
```bash
pacstrap -K /mnt base linux-lts linux-lts-headers linux-firmware base-devel
```

## Post-install Setup

### Automate mounting
```bash
genfstab -U /mnt >> /mnt/etc/fstab
# verify
cat /mnt/etc/fstab
```

### System Configurations
```bash
# simulate booting into the new host
arch-chroot /mnt
# set time zone
ln -sf /usr/share/zoneinfo/Area/Location /etc/localtime
hwclock --systohc
# set network name
echo "name" >> /etc/hostname
# set root password
passwd
# Install some basic packages
pacman -S vim bash-completion networkmanager
```

### Setup bootloader
```bash
# systemd-boot
bootctl --path=/boot install
# edit /boot/loader/loader.conf
"""
default arch-lts.conf
timeout 3
console-mode keep
"""
# add entry to /boot/loader/entries/arch-lts.conf
"""
title   Arch Linux LTS
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw
"""
# cat /etc/fstab (use root, not swap or boot)
```
Reboot and see if you get in

### Use custom keyboard
```bash
sudo mkdir -p /usr/local/share/kbd/keymaps/
sudo cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/local/share/kbd/keymaps/swapCapsEsc.map.gz
# Modify keyboard layout
cd /usr/local/share/kbd/keymaps
gunzip swapCapsEsc.map.gz
vim swapCapsEsc.map
"""
keycode 1 = Caps_Lock
keycode 58 = Escape
"""
gzip swapCapsEsc.map
# Set it as the default by editing/creating /etc/vconsole.conf
vim /etc/vconsole.conf
"""
KEYMAP=capsesc
"""
# Test keymap
loadkeys swapCapsEsc.map.gz
```

## Setup User space

### Set default editor
```bash
echo "export EDITOR=vim" >> /root/.bashrc
```

### Add user
```bash
# make a user with a home dir and shell
useradd -m -s /bin/bash <username>
passwd <username>
# add user to wheel group (sudo-er)
usermod -aG wheel username
# turn on the wheel group 
visudo /etc/sudoers
# Uncomment >  # %wheel ALL=(ALL:ALL) ALL
```

### Setup networking
Swap out `systemd-networkd` with `networkmanager`
```bash
# Install network manager
pacman -S networkmanager
# Disable networkd
systemctl disable --now systemd-networkd
systemctu status systemd-networkd
# Turn on network manager
systemctl enable --now NetworkManager
nmcli device status
# Insure resolved
resolvectl status
systemctl status systemd-resolved
systemctl enable --now systemd-resolved
```

### Setup package managers
```bash
# initialize and update GPG keys
pacman-key --init
pacman-key --populate archlinux
# Install pactree (dependency visualizer)
pacman -S pacman-contrib
```
* AUR (Arch User Repository)
  * `makepkg` compiles packages from source so `pacman` can install them
  * `paru`(rust) and `yay`(go) are AUR package manager helpers
```bash
mkdir ~/repos
cd ~/repos
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```


### Common Packages
```bash
# Terminal stuff
sudo pacman -S zsh neovim tmux ghostty starship
sudo pacman -S git openssh htop
```

## GPU 

### Install Drivers
```bash
sudo pacman -S vulkan-radeon 
# maybe "mesa" if you need openGL support
sudo pacman -S amdgpu_top
```

## Desktop Setup

### Terminology

* Desktop Protocol: 
  * How apps talk to the graphics hardware
* Compositor:
  * Handles window placement, animations, transparency, tearing prevention, etc.
* Window Manager:
  * Decides window layout, borders, focus, tiling/stacking.
* Desktop Environment:
  * Full integrated suite: panels, settings, file manager, login, etc.
* Extras: Status bars, launchers, notifications, lock screen, etc

Hyprland = Window-Manager + Compositor

### Hyprland
```bash
# the Window-Manager & Compositor 
sudo pacman -S hyprland
# compatibility for apps that don't support Wayland yet
sudo pacman -S xorg-xwayland
# status bar 
sudo pacman -S waybar
# App launcher 
sudo pacman -S hyprlauncher
# Wallpaper
sudo pacman -S hyprpaper
# Lock screen + Idle: hyprlock + hypridle
# Notifications: dunst or swaync
sudo pacman -S dunst
# Audio
sudo pacman -S pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
# Clipboard
sudo pacman -S wl-clipboard
# Screen sharing/Portals
sudo pacman -S xdg-desktop-portal-hyprland
# Polkit (authentication prompts)
sudo pacman -S hyprpolkitagent
# Brightness/Other: brightnessctl, wl-gammactl
# File manager: dolphin, nautilus, or thunar
sudo pacman -S  dolphin
# Theming: nwg-look (for GTK), qt5ct/qt6ct, kvantum
# Login Manager: sddm (recommended) or greetd + tuigreet
# Extras
# qt5-wayland qt6-wayland (Qt apps look good)
# grim slurp (screenshots)
# wl-clip-persist, cliphist (clipboard history)
```

### Nerd Font: [Pick a font (Agave)](https://www.nerdfonts.com/font-downloads)
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Agave.zip
unzip Agave.zip
fc-cache .local/share/fonts
```

### Login

### Applications 
```bash
# browser
sudo paru -S zen-browser
# > zen-browser
# > onnxruntime-opt-rocm

# vim `/etc/pacman.conf`
# uncomment to unable multilib
"""
[multilib]
Include = /etc/pacman.d/mirrorlist
"""
sudo pacman -S steam
```




localectl set-x11-keymap us "" "" "caps:swapescape
setxkbmap -option caps:swapescape



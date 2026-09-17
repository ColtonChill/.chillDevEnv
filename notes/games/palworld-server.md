# Set up Palworld server via incus

## If this is the first time you've used incus
Install incus, and add yourself to `incus-admin` group.
```bash
sudo systemctl enable --now incus
incus admin init
sudo usermod -v 1000000-1000999999 -w 1000000-1000999999 root
```

## make container from scratch
```bash
# incus launch images:debian/13 palworld
incus launch images:archlinux palworld
incus config device add palworld 8211-udp-proxy proxy \
    listen=udp:0.0.0.0:8211 \
    connect=udp:127.0.0.1:8211
```

### Setup steam user
```bash
useradd -m steam 
passwd steam
visudo /etc/sudoers
# Uncomment >  # %wheel ALL=(ALL:ALL) ALL
usermod -aG wheel steam
```

### Install steamcmd
```
su steam && cd /home/steam
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
# wait to build
paru -S steamcmd
```

### install palworld
```
steamcmd +login anonymous +app_update 2394010 validate +quit
cd /home/steam/.steam/steam/SteamApps/common/PalServer/
```
#### update palworld
```
steamcmd +login anonymous +force_install_dir /home/steam/.steam/steam/SteamApps/common/PalServer/ +app_update 2394010 validate +quit
```

## Setup server
```
~/.steam/steam/SteamApps/common/PalServer/PalServer.sh
cp /home/steam/.steam/steam/SteamApps/common/PalServer/DefaultPalWorldSettings.ini \
   /home/steam/.steam/steam/SteamApps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
# edit values
AdminPassword="********"
ServerPassword="********"
ServerName="Chill Palworld"
BuildObjectDamageRate=0.500000
BuildObjectDeteriorationDamageRate=0.000000
```

### Make server systemd service

sudo vim /etc/systemd/system/palworld.service

```
``[Unit]
Description=Palworld Dedicated Server
After=network.target

[Service]
User=steam
Group=steam
WorkingDirectory=/home/steam/
ExecStart=/home/steam/.steam/steam/SteamApps/common/PalServer/PalServer.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
sudo systemctl daemon-reload
sudo systemctl enable --now palworld


## Stop server

incus exec palworld systemctl stop palworld
incus exec palworld systemctl start palworld

## Port forward

### Set up NAT
Firewall → NAT → Destination NAT
* Interface: WAN
* Protocol: UDP
* Destination Address: WAN address
* Destination Port: 8211
* Redirect Target IP: 192.168.1.100
* Redirect Target Port: 8211

### Open Firewall hole
Firewall → Rules → WAN

Enter similar values

## Mods

Add these files add the following path (where PalServer.sh is)
```
# cd /home/steam/.steam/steam/SteamApps/common/PalServer
mkdir -p Mods/Workshop/[any folder name]
touch Mods/Workshop/[any folder name]/Info.json
touch Mods/PalModSettings.ini
```

Push locally download mod from workshop to server.
```
incus file push -r ~/.steam/steam/steamapps/workshop/content/1623730/* palworld/home/steam/.steam/steam/SteamApps/common/PalServer/Mods/Workshop

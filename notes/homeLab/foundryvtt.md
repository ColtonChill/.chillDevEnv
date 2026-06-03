# Setting up Foundry-VTT

## Setup container
```bash
# Create Incus custom volume for app data
incus storage volume create zfs-incus foundry-config
# Launch base image
incus launch images:debian/13 foundry --storage zfs-incus
# Set a static IP for the container (pick one not in use)
incus config device override foundry eth0
incus config device set foundry eth0 ipv4.address 10.10.10.110
# Proxy Foundry's default port to the host
incus config device add foundry 30000-proxy proxy \
    listen=tcp:0.0.0.0:30000 \
    connect=tcp:127.0.0.1:30000
# Make container start automatically
incus config set foundry boot.autostart=true
```

## Attach Incus volumes to the Foundry container
```bash
# Incus-managed volume for Foundry user data (worlds, assets, configs)
incus config device add foundry foundry-config disk \
    pool=zfs-incus \
    source=foundry-config \
    path=/opt/foundry/data
# Reboot
incus exec foundry reboot
```

## Incus Foundry
```bash
# Login to container
incus shell foundry
# Install Node.js 24
apt install -y curl
curl -sL https://deb.nodesource.com/setup_24.x | bash -
apt install -y nodejs

# Create application and user data directories
mkdir -p /opt/foundry/app   # foundryvtt  
mkdir -p /opt/foundry/data  # foundrydata 

# Create a dedicated service user
useradd -r -s /usr/sbin/nologin -d /opt/foundry foundry

# Install the software
# Follow this link: https://foundryvtt.com/community/coltonchill/licenses
# Choose the Node.js version, and copy the timed URL
curl -L "https://YOUR_TIMED_DOWNLOAD_URL_HERE" -o /tmp/foundryvtt.zip
apt install -y unzip
unzip /tmp/foundryvtt.zip -d /opt/foundry/app
chown -R foundry:foundry /opt/foundry/app

# Start running the server (FoundryVTT V13 and newer)
node /opt/foundry/app/main.js --dataPath=/opt/foundry/data

# Fix user permissions
chown -R foundry:foundry /opt/foundry
```

## Create Systemd service
```bash
# Create the service unit
cat > /etc/systemd/system/foundryvtt.service << 'EOF'
[Unit]
Description=Foundry VTT
After=network.target

[Service]
User=foundry
WorkingDirectory=/opt/foundry/app
ExecStart=/usr/bin/node /opt/foundry/app/resources/app/main.js --dataPath=/opt/foundry/data
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now foundryvtt
systemctl status foundryvtt
```

#!/bin/sh

# In the container, delete everything in /app:
rm -rf /app/*

# Copy the updated code to the container:
rsync -ravP /root/shared/midnight/* --exclude build --exclude Midnight-Example-Server --exclude node_modules /app/

# Copy the dist folder to the container:
rsync -ravP /root/shared/sigma/_build-rocky-release/dist/* /app/Midnight-Translation-Server/sigma-icd/
# Copy the attached config.local.json file to the container:
rsync -ravP /root/config.local.json /app/Midnight-User-Interface/public/

# Build the node modules (in the container):
cd /app/Midnight-Web-Server
npm ci
cd /app/Midnight-User-Interface
npm ci
cd /app/Midnight-ATR
npm ci

# Build the C++ (in the container):
cd /app/Midnight-Translation-Server
mkdir build
cd build
cmake ..
make -j8

# Reboot
reboot


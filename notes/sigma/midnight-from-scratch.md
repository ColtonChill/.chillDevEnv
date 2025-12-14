## Launch new image

incus launch Sigma:midnight-rocky9 <container>

## Set up shared disk

incus config set <container> security.privileged true
incus config set <container> security.nesting true
```
incus config device add <container> sigma_src disk path=/root/shared/sigma source='/home/chill/work/sigma'
incus config device add <container> midnight_src disk path=/root/shared/midnight source='/home/chill/work/midnight'
incus config set <container> raw.lxc 'lxc.apparmor.profile=unconfined'
incus config set <container> security.apparmor.unconfined true
```

## Set up local bridge connection

incus config device add <container> eth1 nic nictype=bridged parent=br0
```
# in container
nmcli connection add type ethernet con-name host-br0 ifname eth1 autoconnect yes ipv4.addresses 192.168.0.222/24 ipv4.method manual
nmcli connection up host-br0
```

## install latest cmake from source
```
git clone https://github.com/Kitware/CMake.git
cd CMake/
./bootstrap && make -j8 && sudo make install
```

## Update `.bashrc`
```
# vim ~/.bashrc

export SERVER_IP=10.10.10.170
export SIGMA_IP=10.10.10.28
export APP_IP_ADDRESS=0.0.0.0
export DB_HOST=localhost
export VITE_MWS_HOST=$SERVER_IP
export ROAD_SERVICE_URL=http://10.5.0.136:8089
export MTS_SERVER_PATH=/root/shared/midnight/Midnight-Translation-Server/build/bin/server
```
## Install Sigma dependencies and build sigma

## Build Midnight

### Install Midnight dependencies
```
pip install "conan<2.0"
```

### Copy Version.txt & FindTsbExtern.cmake
```
cp ~/shared/sigma/_build-rocky9-release/Version.txt ~/shared/sigma/_build-rocky9-release/dist/Version.txt
mkdir ~/shared/sigma/_build-rocky9-release/dist/Modules
cp ~/shared/sigma/toolchains/Modules/FindTsbExtern.cmake ~/shared/sigma/_build-rocky9-release/dist/Modules/FindTsbExtern.cmake
```

### Link Sigma ICD 
```
# Inside the container, replace the mock sigma server in midnight with the real thing
cd /root/shared/midnight/Midnight-Translation-Server
rm -rf sigma-icd
ln -s /root/shared/sigma/_build-rocky9-release/dist sigma-icd
```

### Build midnight
```
cd /root/shared/midnight/Midnight-Translation-Server/build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j8
```


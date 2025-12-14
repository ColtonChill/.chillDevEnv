## Ubuntu
1. Install latest tsb-exter
2. install latest sigma.deb
3.  
    ```
    sudo apt install libjpeg-dev libcurl3-gnutls 
    sudo apt install libtiff5-dev  # missing tiffio.h
    ```
4. add `net.core.wmen=2097512` to `/etc/sysctl.conf`

## Jetpack
1. `sudo apt install ./tsb-extern.deb`
2. `sudo apt install mariadb-client mariadb-server`
2. `sudo apt install libmariadb3`
2. `sudo apt install ./sigma.deb`

## Rocky
```
dnf install epel-release
dnf install gcc g++ git vim openssh-server openssl-devel java-openjdk-headless libtiff-devel curl-devel libpng-devel MariaDB-devel libjpeg-turbo-devel

### Might need this (tsb-extern experiments)???
dnf install libicu-devel
```

### Cuda
```
dnf install 'dnf-command(config-manager)'
dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel@ROCKY_VER@/x86_64/cuda-rhel@ROCKY_VER@.repo
dnf clean all
dnf install cuda-toolkit-11-8 cudnn tensorrt-libs tensorrt-devel libnvinfer-devel libnvinfer-bin
# write to .bashrc
export PATH="$PATH:/usr/local/cuda/bin"
```

### tsb-extern
```
dnf install libuuid-devel libusbx-devel rpm-build
```

### Nice things
* Helps find packages via (`dnf provides */name.h`)
  `dnf-utils`
* Tab completion
  `bash-completion`
* cmake re-building tools/helpers
  `libtool automake`


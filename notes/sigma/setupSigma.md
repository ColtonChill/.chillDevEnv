## Ubuntu
1. Install latest tsb-extern
2. 
    ```
    sudo apt install -y ca-certificates curl gnupg
    curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc | sudo gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg

    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main' | sudo tee /etc/apt/sources.list.d/kitware.list

    sudo apt update && sudo apt install cmake
    ```
3.  
    ```
    sudo apt install gcc g++ git libmariadb-dev libicu-dev bash-completion
    sudo apt install libjpeg-dev libpng-dev libcurl4-gnutls-dev libssl-dev libtiff5-dev openjdk-25-jdk
    sudo apt install libsystemd-dev
    ```
4. add `net.core.wmen=2097512` to `/etc/sysctl.conf`

### Building tsb-extern

## Ubuntu 
```
sudo apt install cuda-toolkit-11-8 cudnn tensorrt-libs tensorrt-dev libnvinfer-dev libnvinfer-bin
sudo apt install cuda
```




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
#### Cuda (runtime)
```bash
sudo dnf -y module install nvidia-driver:open-dkms
```

### tsb-extern
```bash
dnf install openh264-devel
dnf install libuuid-devel libusbx-devel rpm-build cyrus-sasl-devel
# Maybe needed for "fastdds_Release" for the time being
dnf -y install bison
dnf install https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm
dnf install https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
dnf clean all
dnf makecache
dnf install foonathan-memory-devel
```

#### Nice things
* Helps find packages via (`dnf provides */name.h`)
```
dnf install dnf-utils bash-completion libtool automake
```

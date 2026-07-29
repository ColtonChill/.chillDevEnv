# For building sigma


## Ubuntu
1. Install latest tsb-extern
2. 
    ```bash
    sudo apt install -y ca-certificates curl gnupg
    curl -fsSL https://apt.kitware.com/keys/kitware-archive-latest.asc | sudo gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg

    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main' | sudo tee /etc/apt/sources.list.d/kitware.list

    sudo apt update && sudo apt install cmake 

    # if you need a spesific version
    # list versions avaliable
    apt-cache policy cmake cmake-data
    # install cmake and cmake-data at the same time (for some stupid reason)
    sudo apt install \
      cmake=3.31.12-0kitware2ubuntu24.04.1 \
      cmake-data=3.31.12-0kitware2ubuntu24.04.1
    ```
3.  
    ```
    sudo apt install gcc g++ git libmariadb-dev libicu-dev bash-completion
    sudo apt install libjpeg-dev libpng-dev libcurl4-gnutls-dev libssl-dev libtiff5-dev openjdk-25-jdk
    sudo apt install libsystemd-dev python3-dev
    ```
4. add `net.core.wmen=2097512` to `/etc/sysctl.conf`

### Building tsb-extern
```bash
sudo apt install libsasl2-dev libssl-dev libcurl4-gnutls-dev libtiff5-dev
sudo apt install libusb-1.0-0-dev uuid-dev
sudo apt install libyaml-cpp-dev liblz4-dev libarchive-dev liblzma-dev
```

### Cuda
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update

sudo apt install cuda-toolkit-12-9 cudnn tensorrt-libs tensorrt-dev libnvinfer-dev libnvinfer-bin
sudo apt install cuda-12-9
sudo apt install nvidia-open
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
dnf install yaml-cpp-devel lz4-devel libarchive-devel xz-devel
```

#### Nice things
* Helps find packages via (`dnf provides */name.h`)
```
dnf install dnf-utils bash-completion libtool automake
```

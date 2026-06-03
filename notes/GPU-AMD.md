[AMD docs](https://rocm.docs.amd.com/projects/HIP/en/latest/install/install.html)

Show gpu info:
```
sudo lshw -C display
inxi -G
```

### tensorflow
pip install tensorflow-rocm==2.16.1 -f https://repo.radeon.com/rocm/manylinux/rocm-rel-6.2 --upgrade

### pytorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2

### Drivers

[link](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html#uninstall-kernel-driver)

sudo apt install --reinstall mesa-vulkan-drivers mesa-vulkan-drivers:i386


## Scratch notes:
```bash
# Register Repositories
wget https://repo.radeon.com/amdgpu-install/7.2.4/ubuntu/noble/amdgpu-install_7.2.4.70204-1_all.deb
sudo apt install ./amdgpu-install_7.2.4.70204-1_all.deb
sudo apt update
# Remove old divers
sudo apt autoremove amdgpu-dkms
reboot
# Install drivers
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms
# Install ROCm
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME # Add the current user to the render and video groups
sudo apt install rocm
```

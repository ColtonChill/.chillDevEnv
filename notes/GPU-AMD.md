[https://rocm.docs.amd.com/projects/HIP/en/latest/install/install.html](https://rocm.docs.amd.com/projects/HIP/en/latest/install/install.html)

### tensorflow
pip install tensorflow-rocm==2.16.1 -f https://repo.radeon.com/rocm/manylinux/rocm-rel-6.2 --upgrade

### pytorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2

### Drivers


[Link](https://www.amd.com/en/support/download/linux-drivers.html)

sudo apt install --reinstall mesa-vulkan-drivers mesa-vulkan-drivers:i386


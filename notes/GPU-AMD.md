[AMD docs](https://rocm.docs.amd.com/projects/HIP/en/latest/install/install.html)

Show gpu info:
```
sudo lshw -C display
```

### tensorflow
pip install tensorflow-rocm==2.16.1 -f https://repo.radeon.com/rocm/manylinux/rocm-rel-6.2 --upgrade

### pytorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2

### Drivers


[Link](https://www.amd.com/en/support/download/linux-drivers.html)

sudo apt install --reinstall mesa-vulkan-drivers mesa-vulkan-drivers:i386


## Scratch notes:
apt autoremove warnings I got when I removed the gpu
```
/etc/kernel/prerm.d/dkms:
dkms: removing: amdgpu 6.10.5-2084815.24.04 (6.8.0-85-generic) (x86_64)
Module amdgpu-6.10.5-2084815.24.04 for kernel 6.8.0-85-generic (x86_64).
Before uninstall, this module version was ACTIVE on this kernel.

amdgpu.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.

amdttm.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.

amdkcl.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.

amd-sched.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.

amddrm_ttm_helper.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.

amddrm_buddy.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.

amdxcp.ko.zst:
 - Uninstallation
   - Deleting from: /lib/modules/6.8.0-85-generic/updates/dkms/
 - Original module
   - No original module was found for this module on this kernel.
   - Use the dkms install command to reinstall any previous module version.
depmod...
```

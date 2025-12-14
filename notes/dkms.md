# DKMS = Dynamic Kernel Module Support.



## DKMS flow for NVIDIA driver

Deletes the module from all kernels. Useful if you want to clean up before reinstalling.
```
sudo dkms remove -m nvidia -v 580.95.05 --all
```

Shows what modules DKMS knows about and which kernels they’re installed for.
```
dkms status
```

Add the driver to DKMS (usually done automatically by NVIDIA RPM):
```
sudo dkms add -m nvidia -v 580.95.05
```

Build it for the current kernel:
```
sudo dkms build -m nvidia -v 580.95.05
```

Install it:
```
sudo dkms install -m nvidia -v 580.95.05
```

Load the module:
```
sudo modprobe nvidia
```

Verify:
```
nvidia-smi
```
After that, DKMS will auto-build this module for any new kernel you install in the future.


sudo udevadm control --reload-rules
udevadm trigger

## Resource
>>>
[link](https://opensource.com/article/18/11/udev)

## Example
>>>
99-dragoneye.rules
```
SUBSYSTEM=="tty", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", SYMLINK+="ttyDragoneyeGimbal"

SUBSYSTEM=="video4linux", ATTRS{idVendor}=="1f6a", ATTRS{idProduct}=="15ad", SYMLINK+="ttyDragoneyeVideo"

SUBSYSTEM=="video4linux", ATTRS{idVendor}=="1164", ATTRS{idProduct}=="757a", SYMLINK+="ttyDragoneyeVideo"
```

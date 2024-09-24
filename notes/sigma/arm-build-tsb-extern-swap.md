### How to hot swap tsb-extern versions

1. make a tsb-extern dir using dpkg
  * mkdir /opt/jetson/tsb-extern-jetpack
  * sudo dpkg -x ~/tsb-extern/jetpack5/tsb-extern-1.16.1_8dcaef8-gcc930-jetpack5.deb /opt/jetson/tsb-extern-jetpack

2. (re)make the symlink
  * sudo rm /opt/jetson/jetpack5-gcc/aarch64-buildroot-linux-gnu/sysroot/opt
  * sudo ln -s /opt/jetson/tsb-extern-jetson/opt /opt/jetson/jetpack5-gcc/aarch64-buildroot-linux-gnu/sysroot/opt

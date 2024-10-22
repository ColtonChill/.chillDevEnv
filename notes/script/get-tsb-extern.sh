#!/bin/bash
set -e

server=tsb-server
archs=(Jetpack5 Rocky8 Rocky9 Ubuntu22 UbuntuArm)

for arch in "${archs[@]}"; do
  mkdir -p "$arch"
  rsync -azPv "$server:~/tsb-extern-pkgs/$arch/tsb-extern"*.* "$arch/"
done

## Install the sdk for jetpack6 builds
```bash
SYSROOT=/opt/jetson/jetpack6-gcc/aarch64-buildroot-linux-gnu/sysroot
SDK=/home/cchill/work/raptor-guide/Raptor-Guide-v1_0_0/raptor-sdk/jetson-linux36-armv8/raptor-sdk-1.0.0-jetson-linux36-aarch64

mkdir -p "$SYSROOT/usr/local/include" "$SYSROOT/usr/local/lib"
cp -r "$SDK/include/." "$SYSROOT/usr/local/include/"
find "$SDK/lib" -maxdepth 1 \( -name '*.so' -o -name '*.so.*' \) -exec cp -P {} "$SYSROOT/usr/local/lib/" \;

# grab CMake/pkgconfig metadata if the SDK ships it (needed for find_package to work)
[ -d "$SDK/lib/cmake" ]     && cp -r "$SDK/lib/cmake" "$SYSROOT/usr/local/lib/"
[ -d "$SDK/lib/pkgconfig" ] && cp -r "$SDK/lib/pkgconfig" "$SYSROOT/usr/local/lib/"
```
### Installing and copying over vulkan dependency
```bash
sudo apt install libvulkan-dev   # on host Ubuntu24 x86
# Steal them for the jetson build
cp -r /usr/include/vulkan "$SYSROOT/usr/include/"
cp -r /usr/include/vk_video "$SYSROOT/usr/include/" 2>/dev/null || true

# Rip the .so from the jetpack device
scp raptor:/usr/lib/aarch64-linux-gnu/libvulkan.so.1.3.* .
LIBDIR="$SYSROOT/usr/lib/aarch64-linux-gnu"
mv libvulkan.so.1.3.* "$LIBDIR/"
ln -sf libvulkan.so.1.3.204 "$LIBDIR/libvulkan.so.1"
ln -sf libvulkan.so.1     "$LIBDIR/libvulkan.so"
```

## Code
Function Candidates for modification
* cmdInitSpecialized()
* getSolution()
* publishSolution()




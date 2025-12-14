# My understanding

I get this error:
```
/usr/local/lib/libopencv_highgui.so.4.12.0: error adding symbols: file in wrong format
```
Meaning: 
* The linker is trying to link an x86_64 OpenCV shared library into an AArch64 (Jetson) binary.
* That is host library leakage during cross-compilation.


## Fix bugs
```
# Hard wall off host 
set(CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH OFF)
set(CMAKE_FIND_USE_CMAKE_SYSTEM_PATH OFF)
```
results in...
```
/home/chill/work/tsb-extern-bld/_build-jetpack/xpbase/Source/patch/build-aux/missing: line 81: aclocal-1.14: command not found
WARNING: 'aclocal-1.14' is missing on your system.
         You should only need it if you modified 'acinclude.m4' or
         'configure.ac' or m4 files included by 'configure.ac'.
         The 'aclocal' program is part of the GNU Automake package:
         <http://www.gnu.org/software/automake>
         It also requires GNU Autoconf, GNU m4 and Perl in order to run:
         <http://www.gnu.org/software/autoconf>
         <http://www.gnu.org/software/m4/>
         <http://www.perl.org/>
```
fix again with...
```
sudo ln -s /usr/bin/aclocal-1.16 /usr/bin/aclocal-1.14
sudo ln -s /usr/bin/automake-1.16 /usr/bin/automake-1.14
```



```
 cmake -LA | grep -i opencv
CMake Warning:
  No source or binary directory provided.  Both will be assumed to be the
  same as the current working directory, but note that this warning will
  become a fatal error in future CMake releases.


CMake Error: The source directory "/home/chill/work/tsb-extern-bld/_build-jetpack/xpbase/Build/openeb_Release" does not appear to contain CMakeLists.txt.
Specify --help for usage, or press the help button on the CMake GUI.
OpenCV_DIR:PATH=/usr/local/lib/cmake/opencv4
```
```
$ cmake -LA | egrep 'CMAKE_(PREFIX|FIND|SYSROOT)'
CMake Warning:
  No source or binary directory provided.  Both will be assumed to be the
  same as the current working directory, but note that this warning will
  become a fatal error in future CMake releases.



```
```
$ cmake --debug-find-pkg=OpenCV .
Running with debug output on for the 'find' commands for package(s) OpenCV.
-- [mkpatch]  execute only task 0: clone, checkout, make patches
-- [download] execute only step 1: download compressed archives
--            (suitable for light transport)
-- [patch]    execute through step 2: expand and patch
--            (suitable for debug, step into source)
-- [build]    execute through step 3: build the platform-specific binaries
-- XP_STEP: patch
-- [build] -- platform: 64-bit
-- [build] -- configurations: Release
-- XP_STEP: build
-- target apr_Release
-- target activemqcpp_Release
-- target zlib_Release
-- target bzip2_Release
-- target boost_bld
-- target brpc_Release
-- target cli11_Release
-- target cppcheck_Release
-- target librdkafka_Release
-- target cppkafka_Release
-- target libzmq_Release
-- target cppzmq_Release
-- target crossguid_Release
-- target eigen_Release
-- target fastcdr_Release
-- target asio_Release
-- target tinyxml2_Release
-- target foonathanmemoryvendor_Release
-- target fastdds_Release
-- target fastddsgen_Release
-- target yasm_Release
-- target openh264_Release
-- target ffmpeg_Release
-- target fftwd_Release
-- target fftwf_Release
-- target geographiclib_Release
-- target geotiff_Release
-- target geotranz_Release
-- target ipp_Release
-- target json_Release
-- target json-schema-validator_Release
-- target kml_Release
-- target matplotlib_Release
-- target mavlink_Release
-- target mavp2p_Release
-- target msgpack_Release
-- target nmea_Release
-- target protobuf_Release
-- target opencv_Release
-- target openeb_Release
-- target orion_Release
-- target patch_bld
-- target pugixml_Release
-- target rapidxml_bld
-- target realsense_Release
-- target sofa_Release
-- target vectornav_Release
-- Configuring done (1.2s)
-- Generating done (0.1s)
-- Build files have been written to: /home/chill/work/tsb-extern-bld
```
```

```

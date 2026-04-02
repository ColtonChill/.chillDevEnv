[Tutorial](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)

TLDR;

## Dependencies
```bash
# Open up debian to "non-free" sources (libfdk-aac)
sudo sed -i 's/main/main non-free/g' /etc/apt/sources.list
sudo apt update
# Maybe (depending on how bare bones you are)
sudo apt -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libmp3lame-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev
sudo apt install libunistring-dev libaom-dev libdav1d-dev bzip2 
# An assembler used by some libraries.
sudo apt install nasm 
# libx264
sudo apt install libx264-dev
# libx265
sudo apt install libx265-dev libnuma-dev
# libvpx
sudo apt install libvpx-dev
# libfdk-aac
sudo apt install libfdk-aac-dev
# libopus
sudo apt install libopus-dev
```

## Install ffmpeg
```bash
mkdir -p ~/ffmpeg_sources ~/bin

cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 && \
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libdav1d \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r

# Add new commands to path (.bashrc)
export PATH="${PATH:+${PATH}:}/path/to/new/directory"   
```

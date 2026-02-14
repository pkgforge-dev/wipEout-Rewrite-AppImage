#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake    \
    glew     \
    libdecor \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of wipEout-Rewrite..."
echo "---------------------------------------------------------------"
REPO="https://github.com/phoboslab/wipeout-rewrite"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./wipEout-Rewrite
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./wipEout-Rewrite
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release
#    -DPATH_USERDATA="$HOME/"
make -j$(nproc)
mv -v wipeout ../../AppDir/bin/wipegame
wget https://phoboslab.org/files/wipeout-data-v01.zip -O wipeout-data.zip && bsdtar -xvf wipeout-data.zip && rm wipeout-data.zip
mv -v wipeout ../../AppDir/bin/

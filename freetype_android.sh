#!/bin/bash
# Place this file in the same folder as a freetype SVN checkout.

# Configurable to your taste
NDK_TOOLCHAIN="${HOME}/android-ndk-r8d"
PLATFORM="android-9"

# Architectures for which we shall build:
TOOLCHAIN="arm-linux-androideabi-4.7"

# Location to create the temporarily toolchain, this toolchain will
# contain a copy of the compiler, linker, libstdc++ et cetera.
TMPDIR="$(pwd)/androidtoolchain/"
`mkdir -p ${TMPDIR}`

# Take notion of the current path, we can restore
# the path lateron using this copy.
OLDPATH=${PATH}

# Add NDK to path:
export PATH="$NDK_TOOLCHAIN/bin/:$PATH"

# Add the cross compile tool chain to the path:
export PATH="${TMPDIR}/bin/:${PATH}"

# Remove old tool chain, perhaps not as performant, but this script
# is only ran once, ideally.
`rm -rf ${TMPDIR}/*`

echo "Generating standalone toolchain for '${TOOLCHAIN}':"

# Inside the NDK folder read: /android-ndk-r8d/docs/STANDALONE-TOOLCHAIN.html
echo `${NDK_TOOLCHAIN}/build/tools/make-standalone-toolchain.sh --toolchain=${TOOLCHAIN} --platform=${PLATFORM} --install-dir=${TMPDIR}`

# Specify environment for make:
export CC=arm-linux-androideabi-gcc
export CXX=arm-linux-androideabi-g++

# Household stuff, remnants from other builds:
make clean
rm -rf objs/.libs/*

# Configure, make and copy the lib to a convenient location:
./configure \
--host=arm-linux-androideabi \
--without-zlib \
--prefix=${TMPDIR} && make && cp objs/.libs/libfreetype.a libfreetype-${TOOLCHAIN}.a

# Restore the old PATH environment:
export PATH=${OLDPATH}

# Exit without errors:
exit 0

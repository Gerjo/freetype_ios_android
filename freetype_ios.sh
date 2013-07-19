#!/bin/bash
# Place this file in the same folder as a freetype SVN checkout.
VERSION="6.1"
MINVERSION="4.3"
ARCHES=("armv7" "armv7s" "i386")
PLATFORMS=("iPhoneOS" "iPhoneOS" "iPhoneSimulator")
MERGE="lipo -create -output libfreetype-fat.a "

for i in ${!ARCHES[@]} 
do
    # Create required paths:
    ARCH=${ARCHES[${i}]}
    PLATFORM=${PLATFORMS[${i}]}
    SDK="/Developer/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${VERSION}.sdk"
    SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${VERSION}.sdk"
    OUT="./libFreetype2-${ARCH}.a"
    
    # Clean old remnants:
    make clean; rm -rf objs/.libs/*

    # Usual configure and make routines:
    ./configure --prefix=/Users/gerjo/freetype-2.4.10/build-${ARCH} --host=arm-apple-darwin --enable-static=yes --enable-shared=no \
    CPPFLAGS="-arch ${ARCH} -fpascal-strings -Os -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=${VERSION} -I${SDK}/usr/include/libxml2 -isysroot ${SYSROOT}" \
    CC=`xcrun -sdk iphoneos -find clang` \
    CFLAGS="-arch ${ARCH} -fpascal-strings -Os -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=${VERSION} -isysroot ${SYSROOT}" \
    LD=`xcrun -sdk iphoneos -find ld` \
    LDFLAGS="-arch ${ARCH} -isysroot ${SYSROOT} -miphoneos-version-min=${MINVERSION}" \
    AR=`xcrun -sdk iphoneos -find ar` && make
    
    # Copy the file, and append it to the merge command.
    cp objs/.libs/libfreetype.a ${OUT}
    MERGE="${MERGE} ${OUT}"
done

# Execute the merge command, output some debug info:
echo `${MERGE}` && lipo -info libfreetype-fat.a

exit 0

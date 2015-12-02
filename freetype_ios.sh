#!/bin/bash
# Place this file in the same folder as a freetype SVN checkout.
VERSION="9.1"		# SDK version
MINVERSION="6.1"	# Target version.
ARCHES=("arm64" "armv7" "armv7s" "i386")
PLATFORMS=("iPhoneOS" "iPhoneOS" "iPhoneOS" "iPhoneSimulator")
MERGE="lipo -create -output libfreetype-fat.a "

for i in ${!ARCHES[@]} 
do
    # Create required paths:
    ARCH=${ARCHES[${i}]}
    PLATFORM=${PLATFORMS[${i}]}
    SYSROOT="/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${VERSION}.sdk"
    SDK=${SYSROOT}
	OUT="./libFreetype2-${ARCH}.a"
    
	if [ ! -e ${SDK} ]; then
		echo "SDK not found at:"
		echo ${SDK}
		echo ""
		echo "Try changing the 'version' inside this bash file. Here are some installed SDKs:"
		echo $(ls $(dirname ${SDK}))
		echo ""
		exit 1
	fi
	
    # Clean old remnants:
    make clean; rm -rf objs/.libs/*

    # Usual configure and make routines:
    ./configure --prefix=${PWD}/build-${ARCH} --host=arm-apple-darwin --enable-static=yes --enable-shared=no --with-bzip2=no \
    CPPFLAGS="-arch ${ARCH} -fpascal-strings -Os -fembed-bitcode-marker -fembed-bitcode -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=${VERSION} -I${SDK}/usr/include/libxml2 -isysroot ${SYSROOT}" \
    CC=`xcrun -sdk iphoneos -find clang` \
    CFLAGS="-arch ${ARCH} -fpascal-strings -Os -fembed-bitcode-marker -fembed-bitcode -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=${VERSION} -isysroot ${SYSROOT}" \
    LD=`xcrun -sdk iphoneos -find ld` \
    LDFLAGS="-arch ${ARCH} -isysroot ${SYSROOT} -miphoneos-version-min=${MINVERSION}" \
    AR=`xcrun -sdk iphoneos -find ar` && make
    
    # Copy the file, and append it to the merge command.
    cp objs/.libs/libfreetype.a ${OUT}
    MERGE="${MERGE} ${OUT}"
done


echo ""
# Execute the merge command, output some debug info:
echo `${MERGE}` && lipo -info libfreetype-fat.a

echo ""
echo "If there was an error, try running \"xcode-select --install\" (in particular for x86 simulator builds.";

echo ""
exit 0

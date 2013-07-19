freetype_ios_android
====================

Convenient scripts to configure the FreeType2 toolchain to build static libraries for Android and iOS. These scripts offer a modern alternative to the out-of-date repositories found at _https://github.com/cdave1/freetype2-android_ and _https://github.com/cdave1/freetype2-ios_.


Both scripts were part of my graduation project at Game Oven Studios. I'm releasing the scripts in the hope it will be of use to someone else, too. Each script is well-documented and contains easily configurable variables.

Usage:
====================
Get a copy of the FreeType2 source code. E.g., at http://sourceforge.net/projects/freetype/files/freetype2/

Place either buildscript '_freetype_android.sh_' or '_freetype_ios.sh_' in the FreeType folder. Run either script through '_./freetype_android.sh_' or '_freetype_ios.sh_'. The build artifacts (static library) will appear in the same folder.

You may need to make the buildscripts executable, '_chmod +x freetype_ios.sh_' should do the trick. Each script contains a few variables that specify SDK locations - you may need to configure those.


iOS notes:
====================
The iOS static library will be compatible with _armv7_, _armv7s_ and _i386_. The latter is required for the iOS simulator.


Android notes:
====================
The Android static library will only contain _arm7_ instructions. The script could easily be adjusted to include _MIPS_ and _i386_ compatible instructions.


Compatibility:
====================
The scripts are only tested on OS X 10.8 - The Android script may work on Linux, too.


Contact:
====================
Gerard - gerjoo[at]gmail[dot]com

License:
====================
Both buildscripts are released under the MIT license, you will find this license attached to this repository in a separate file.
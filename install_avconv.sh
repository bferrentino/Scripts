#!/bin/sh
#
# written by bferrentino
#

# installation of pre-requisite tools to properly install avconv
# this script should be modified to run as root, to prevent the necessary sudo entries.

# required stor locations for xcode and command line tools install

MNTDIR="/path/to/tmp/dir"
REMOTEMNT="remotehost/folder"
MNTTYPE="afp,smbfs,nfs"
INSTDIR="/path/to/local/inst/dir"

# if required, credentials will need to be supplied

MNTUSER="myuser"
MNTPASS="userpass"

# mount the location and copy required files. This makes an assumption that all files are properly copied and located in one clean location.

mkdir ${MNTDIR}
mount -t ${MNTTYPE} //${MNTUSER}:${MNTPASS}@${REMOTEMNT} ${MNTDIR}
sleep 3
cd ${MNTDIR}
mkdir ${INSTDIR}
cp -rv * ${INSTDIR}
sleep 3
cd ${INSTDIR}
diskutil unmount ${MNTDIR}
sleep 3
rm -rf ${MNTDIR}


# Install the xcode tools and command line tools. These packages are available for download at developer.apple.com, in downloads
# Some assumptions, and modifications, the Volumes here are set static, but sometimes they can change depending on versions, etc.
# Update all names as copied by your environment. 

hdiutil attach xcode4630916281a.dmg
cd /Volumes/Xcode
cp -R Xcode.app /Applications
cd ${INSTDIR}
diskutil unmount /Volumes/Xcode

# command line tool installer (10.8)

hdiutil attach xcode462_cltools_10_86938259a.dmg


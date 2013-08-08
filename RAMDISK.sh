#!/bin/sh

#  RAMDISK.sh
#  
#
#  Created by Ferrentino, Ben on 8/8/13.
#

DISK_ID=$(hdid -nomount ram://2097152)
newfs_hfs -v Ramdisk ${DISK_ID}
diskutil mount ${DISK_ID}

echo "Enjoy your new Ramdisk! Don't try running this more than once, please"

exit

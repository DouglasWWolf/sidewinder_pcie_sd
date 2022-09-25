#===========================================================
# make_sd_from_prebuilt.sh
#
# Creates a bootable SD that will enable the Sidewinder
# to function as a PCIe device at boot
#
# Author: Doug Wolf
#===========================================================

#<><><><><><><><><><><><><><><><><><><><><><><><><><><>><><>
#    YOU MUST(!!) CHANGE THIS TO BE THE CORRECT DEVICE!
#<><><><><><><><><><><><><><><><><><><><><><><><><><><>><><>
SD=/dev/sdb
#<><><><><><><><><><><><><><><><><><><><><><><><><><><>><><>

#<><><><>><><><><><><><><><><><><><><><><><><><><><><><><><>
#  You must change this to be an existing mount-point
#<><><><>><><><><><><><><><><><><><><><><><><><><><><><><><>
mount_point=/media/$(logname)


# Make sure the SD card device actually exists!
if [ ! -b ${SD} ]; then
    echo "There is no block device called ${SD}"
   exit 1
fi

# Check to ensure we are the root user
if [ $(id -u) -ne 0 ]; then
    echo "Must be run as root.  Use sudo."
    exit 1
fi

# Make absolutely certain that the SD card isn't mounted
umount ${SD}* 2>/dev/null

# Blow away the partition map so the SD card appears empty
echo Erasing ${SD}
dd if=/dev/zero of=${SD} count=65536 >/dev/null 2>/dev/null

# Create a partition:
echo "Partitioning ${SD} with fdisk"
fdisk ${SD} >/dev/null 2>/dev/null <<EOF
n
p
1
2048


w
EOF

# Create the file-system
echo "Making FAT file system on ${SD}1"
mkfs.vfat ${SD}1 >/dev/null


# Make sure the SD card device actually exists!
if [ ! -b ${SD} ]; then
    echo "There is no block device called ${SD}"
   exit 1
fi

# Make sure the mount point actually exists!
if [ ! -d ${mount_point} ]; then
    echo "The mount point ${mount_point} does not exist"
    exit 1
fi

# Figure out the path to our PetaLinux files
path=PREBUILT

# Ensure that the path exists
if [ -z "${path}" ]; then
    echo "Can't find image.ub.  Are you in the right directory?"
    exit 1
fi

# Let's ensure that our SD device isn't mounted anywhere
umount ${SD}* 2>/null

# Now mount the boot partition
echo "Mounting boot partition (${SD}1) on ${mount_point}"
mount ${SD}1 ${mount_point}

# Make sure that the mount worked
if [ $? -ne 0 ]; then
    echo "Failed to mount ${SD}1 on ${mount_point}!"
    exit 1
fi

# Copy the boot files to the SD card
echo "Copying files to boot partition"
cat ${path}/BOOT.BIN.0* >${mount_point}/BOOT.BIN
cp  ${path}/image.ub     ${mount_point}
cp  ${path}/boot.scr     ${mount_point}

# Unmount the boot partition
echo "Unmounting ${SD}1"
umount ${SD}1

# All finished!
echo "Done!"


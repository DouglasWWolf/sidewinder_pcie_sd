if [ -z "$(which petalinux-build)" ]; then
    echo "You forget to source the PetaLinux settings.sh"
    exit 1 
fi

#
# Completely remove any previously built build
#
rm -rf system

#
# Create, configure, build and package PetaLinux in order to get the boot files
#
petalinux-create -t project -s sidewinder-petalinux-2021.1.bsp -n system
cd system
petalinux-config --get-hw-description ../sidewinder_bootsd.xsa
petalinux-build 
petalinux-package --boot --u-boot


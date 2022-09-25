clear
echo "The action you are about to undertake will completely"
echo "clear the PetaLinux object files, and they will have"
echo "to be rebuilt from scratch, which could take an hour."
echo
echo "Are you certain you want to clean the Petalinux build?"
read -p "Type 'yes' to continue, anything else exits: " response

if [[ "$response" != "yes" ]]; then
   echo "No action taken"
   exit 0
fi

echo "Cleaning the build.  This may take a moment..."
rm -rf system
echo "Done"


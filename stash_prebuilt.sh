src=system/images/linux
dest=PREBUILT

rm -rf ${dest}
mkdir  ${dest}

cp ${src}/BOOT.BIN ${dest}
cp ${src}/boot.scr ${dest}
cp ${src}/image.ub ${dest}


cd ${dest}
split -d -a3 -b20M BOOT.BIN BOOT.BIN.
rm BOOT.BIN



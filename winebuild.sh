#!/bin/sh

mult32bit_lib_path="/app/lib/32bit/lib"

export LD_LIBRARY_PATH=/app/lib:${mult32bit_lib_path}
export PATH=${PATH}:/app/lib/32bit/bin

echo ; echo "Configuring 64bit wine" ; echo 

mkdir -p wine_64_build && cd wine_64_build
                
../configure --prefix=/app \
             --libdir=/app/lib \
             --disable-win16 \
             --enable-win64 \
             --with-x \
             --without-cups \
             --without-curses \
             --without-capi \
             --without-glu \
             --without-gphoto \
             --without-gsm \
             --without-hal \
             --without-ldap \
             --without-netapi || exit 1

make --jobs=$(nproc)

cd ..

echo ; echo "Configuring 32bit wine" ; echo 
mkdir -p wine_32_build && cd wine_32_build

mkdir -p ${mult32bit_lib_path}
                
../configure --prefix=/app \
             --libdir=${mult32bit_lib_path} \
             --disable-win16 \
             --with-wine64="../wine_64_build" \
             --with-x \
             --without-cups \
             --without-curses \
             --without-capi \
             --without-glu \
             --without-gphoto \
             --without-gsm \
             --without-hal \
             --without-ldap \
             --without-netapi || exit 1

make --jobs=$(nproc)

echo ; echo "Installing 32bit wine" ; echo 

make prefix=/app libdir=${mult32bit_lib_path} dlldir=${mult32bit_lib_path}/wine install || exit 1

echo ; echo "Installing 64bit wine" ; echo 

cd ../wine_64_build

make prefix=/app libdir=/app/lib dlldir=/app/lib/wine install || exit 1

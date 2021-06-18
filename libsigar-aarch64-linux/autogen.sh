#!/bin/bash

cwd=$(pwd)
patch_file_1="ArchNameTask.java.patch"
patch_file_2="jni-build.xml.patch"
sigar_ver="1.6.4"
src_file="sigar-$sigar_ver.tar.gz"
download_link="https://github.com/hyperic/sigar/archive/refs/tags/$src_file"

err_report() {
    echo "Error on line $1"
    exit 1
}

trap 'err_report $LINENO' ERR

if [ ! -f "$patch_file_1" ];then
    echo "Not found $patch_file_1 file"
    exit 1
fi

if [ ! -f "$patch_file_2" ];then
    echo "Not found $patch_file_2 file"
    exit 1
fi

rm -rf sigar-sigar-$sigar_ver

yum install -y make gcc libtool ant execstack

if [ ! -f "$src_file" ]; then
    wget $download_link
fi

tar -zxpf $src_file
cd sigar-sigar-$sigar_ver

/bin/cp -fv $cwd/$patch_file_1 bindings/java/hyperic_jni/src/org/hyperic/jni/
cd bindings/java/hyperic_jni/src/org/hyperic/jni/
patch -p0 < $patch_file_1
cd -

/bin/cp -fv $cwd/$patch_file_2 bindings/java/hyperic_jni/
cd bindings/java/hyperic_jni/
patch -p0 < $patch_file_2
cd -

cd bindings/java
ant

execstack -c sigar-bin/lib/libsigar-aarch64-linux.so

/bin/mv -fv sigar-bin/lib/libsigar-aarch64-linux.so $cwd
/bin/mv -fv sigar-bin/lib/sigar.jar $cwd

cd $cwd
rm -rf sigar-sigar-$sigar_ver

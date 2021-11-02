#!/bin/bash

#installing packages
yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum -y install bzip2 wget
yum update -y 
yum -y makecache 
yum -y install ncurses-devel make gcc bc flex bison openssl-devel gcc-c++ 
yum -y install elfutils-libelf-devel 
yum -y install rpm-build
yum -y install libmpc-devel mpfr-devel gmp-devel 
#----------------installing gcc 4.9.2-for sources---------------------
#cd ~
#curl ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-4.9.2/gcc-4.9.2.tar.bz2 -O
#tar xfj gcc-4.9.2.tar.bz2
#cd gcc-4.9.2/
#./configure --disable-multilib --enable-languages=c,c++
#make -j 4
#make install
#echo 'preforming path update'
#hash -r
#gcc --version
#export PATH=/usr/local/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH
#gcc --version
#cd ..
#rm -Rf gcc-4.9.2
#rm -f gcc-4.9.2.tar.bz2
#----------------downloading gcc----------------------
yum install -y yum-utils centos-release-scl
yum -y --enablerepo=centos-sclo-rh-testing install devtoolset-7-gcc
source /opt/rh/devtoolset-7/enable
gcc --version
cd /usr/src/
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.14.15.tar.xz
tar -xf linux-5.14.15.tar.xz
cd linux-5.14.15
cp -v /boot/config-$(uname -r) /usr/src/linux-5.14.15/.config
#change kernel parameters
sed -i '/CONFIG_RETPOLINE=y/c\CONFIG_RETPOLINE=n' .config
make olddefconfig
make -j$(nproc) rpm-pkg
#-----------------install rpm-------------------#
rpm -iUv /root/rpmbuild/RPMS/x86_64/*.rpm
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
yum clean all
shutdown -r now

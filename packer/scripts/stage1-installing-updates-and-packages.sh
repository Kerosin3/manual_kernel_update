#!/bin/bash

#installing packages
yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
yum install -y epel-release
yum -y install bzip2 wget
yum update -y 
yum -y makecache 
yum -y install ncurses-devel make gcc bc flex bison openssl-devel gcc-c++ 
yum -y install elfutils-libelf-devel dkms
yum -y install rpm-build
yum -y install libmpc-devel mpfr-devel gmp-devel rsync
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
yum -y install yum-utils centos-release-scl
#yum -y --enablerepo=centos-sclo-rh-testing install devtoolset-7-gcc
#source /opt/rh/devtoolset-7/enable
#echo 'source /opt/rh/devtoolset-7/enable' >> /etc/profile
yum -y --enablerepo=centos-sclo-rh-testing install devtoolset-10-toolchain 
echo '----------------soursing gcc------------------'
echo 'source /opt/rh/devtoolset-10/enable' >> /etc/profile
hash -r
gcc --version
cd /usr/src/
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.14.15.tar.xz
tar -xf linux-5.14.15.tar.xz
cd linux-5.14.15
cp -v /boot/config-$(uname -r) /usr/src/linux-5.14.15/.config
#change kernel parameters
make olddefconfig
sed -i '/CONFIG_RETPOLINE=y/c\CONFIG_RETPOLINE=n' .config
make prepare
make -j$(nproc) rpm-pkg
make headers_install
#-----------------install rpm-------------------#
rpm -ivh /root/rpmbuild/RPMS/x86_64/*.rpm
#rpm -iUv /root/rpmbuild/RPMS/x86_64/*.rpm
echo '----------------deleting BUILD folder for RPM package------------------------'
rm -Rf /root/rpmbuild/BUILD/*
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-set-default 0
yum clean all
shutdown -r now

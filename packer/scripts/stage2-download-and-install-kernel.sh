#!/bin/bash
#------------------compiling kernel (not working because sees wrong gcc version)------------#
#yum clean all
uname -r
#gcc --version
#cd /usr/src/
#wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.14.15.tar.xz
#tar -xf linux-5.14.15.tar.xz
#cd linux-5.14.15
#cp -v /boot/config-$(uname -r) /usr/src/linux-5.14.15/.config
#cp -v /boot/config-3.10.0-1127.el7.x86_64 /usr/src/linux-5.14.15/.config
#export TERM=xterm
#change kernel parameters
#sed -i '/CONFIG_RETPOLINE=y/c\CONFIG_RETPOLINE=n' .config
#make olddefconfig
#make -j$(nproc) rpm-pkg
#-----------------install rpm-------------------#
#rpm -iUv /root/rpmbuild/RPMS/x86_64/*.rpm
#grub2-mkconfig -o /boot/grub2/grub.cfg
#grub2-set-default 0
shutdown -r now


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
#----------------installing gcc 4.9.2----------------------
cd ~
curl ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-4.9.2/gcc-4.9.2.tar.bz2 -O
tar xvfj gcc-4.9.2.tar.bz2
cd gcc-4.9.2/
./configure --disable-multilib --enable-languages=c,c++
make -j$(nproc)
make install
cd ..
rm -Rf gcc-4.9.2
rm -f gcc-4.9.2.tar.bz2
yum clean all
shutdown -r now

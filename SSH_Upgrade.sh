#!/bin/bash

#Pre-requisites
yum -y install pam-devel


#Installation
wget https://fastly.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz
tar zxvf openssh-7.6p1.tar.gz # extract 
cd openssh-7.6p1 
./configure --prefix=/usr --sysconfdir=/etc/ssh --with-md5-passwords --with-pam --with-zlib --without-openssl-header-check --with-ssl-dir=/usr/local/ssl --with-privsep-path=/var/lib/sshd # need to specify openssl the installation path 
#PAM is enabled. You may need to install a PAM control file 
#for sshd, otherwise password authentication may fail. 
#Example PAM control files can be found in the contrib/ 
#subdirectory
make 
make install 


#Configuration
echo 'X11Forwarding yes' >> /etc/ssh/ssh_config # Allows SSH to forward X 
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config # Set SSH to allow root login 
cp -p contrib/redhat/sshd.init /etc/init.d/sshd # Copy the startup script for SSH 
chmod +x /etc/init.d/sshd # Add execute permissions 


#Adding ssh to services
chkconfig --add sshd # added to the system service 
chkconfig sshd on # open sshd boot operation 
service sshd restart # restart SSHD, restart the ssh may be connected to the connection, so be sure to restart before telnet can connect, if you can not ensure that you can only go to the engine room myself.  Up to this openssh upgrade is done 
sshd -V # to view the current version of SSH.


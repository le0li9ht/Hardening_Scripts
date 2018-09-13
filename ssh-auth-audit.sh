#!/bin/bash

#validate whther the sshpass is installed and whether the ip.txt file exists
validation() {
if ! [ -x "$(command -v sshpass)" ]; then
  echo 'Error: sshpass is not installed.' >&2
  echo -e "Installing....\n"
  install_sshpass
  exit 1
else
 if [ ! -f ./ip.txt ]; then
    echo -e "No \"ip.txt\" file found\nPlease create \"ip.txt\" in current directory with the list of ip's to scan"
    exit 1
 fi
fi
}

#run the scan
pass_audit() {
echo -e "**********************\nHi if you have a different ssh port please pass the ssh port as first arguument as shown\n./$0 4222\n*******************\n"
port=22
if ! [ $# -eq 0 ]
  then
    port=$1
fi
for i in `cat ip.txt|grep -o '[0-9]\{0,3\}\.[0-9]\{0,3\}\.[0-9]\{0,3\}\.[0-9]\{0,3\}'`
do
	i=$(echo $i | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
	sshpass -p 'ss' ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -q root@$i -p$port
	if [ $? -eq 5 ]; then
		echo "Password-Based-Enabled For $i"
	else
		continue
	fi

done
}

#install sshpass
install_sshpass() {
 sudo apt-get update
 sudo apt-get -y install sshpass
}

#calling functions
validation
pass_audit

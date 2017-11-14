#!/bin/bash
sudo apt-get update
sudo apt-get install libncurses5-dev libncursesw5-dev
# 以下为可选 可以clone 整个内核 或是 clone drivers 部分
UNAME_R=3.13.0-32-generic
UBUNTU_KERNEL_TAG=Ubuntu-3.13.0-32.57

# git clone git://kernel.ubuntu.com/ubuntu/ubuntu-${DISTRIB_CODENAME}.git
# git checkout ${UBUNTU_KERNEL_TAG}
if [ -d ath9k ];
then
 	echo "has downloaded "
else
	git clone https://github.com/kangqf/ath9k.git 
fi

mkdir ~/ubuntu-trusty
mkdir ~/ubuntu-trusty/drivers
mkdir ~/ubuntu-trusty/drivers/net
mkdir ~/ubuntu-trusty/drivers/net/wireless
mkdir ~/ubuntu-trusty/drivers/net/wireless/ath

cd ath9k 

mv ath/* ~/ubuntu-trusty/drivers/net/wireless/ath/
rmdir ath
cd ..
mv ath9k ~/ubuntu-trusty/drivers/net/wireless/ath/




sudo apt-get update
sudo apt-get install linux-image-${UNAME_R}
sudo apt-get install linux-headers-${UNAME_R}
sudo apt-get install linux-image-extra-${UNAME_R}

cd ~/ubuntu-trusty
make -C /lib/modules/${UNAME_R}/build M=$(pwd)/drivers/net/wireless/ath/ath9k modules

#install module
cd /lib/modules/${UNAME_R}/kernel/drivers/net/wireless/ath/ath9k
for file in ./*.ko; do sudo mv $file $file.orig; done
sudo cp ~/ubuntu-trusty/drivers/net/wireless/ath/ath9k/*.ko .
sudo depmod
sudo modprobe *.ko
echo -e " you need run sudo reboot"

#check the module infomation

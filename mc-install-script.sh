#!/bin/bash
# Minecraft Server Installation Script

:'
 based on: https://www.cloudskillsboost.google/focuses/1852?parent=catalog

 Previous requirements:

- 50GB SSD blank disk named tagged


'


#Steps:

# create directory

echo "Creating minecraft directory..."

if [ ! -d /home/minecraft ]; then
	mkdir -p /home/minecraft;
fi

# Mount and format the persistent disk

if [[ ! $(lsblk /dev/sdb -no fstype) ]]; then 	#if lsblk doesn't return anything it means that the disk is not partitioned
	echo "disk not partitioned";
        echo "starting the partitioning process..."	
	mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-minecraft-disk
else 
	echo "disk is already partitioned";
fi

echo "mouting disk..."
mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft	

# Install and run the Minecraft server

echo "installing dependencies"
apt update

apt install -y software-properties-common screen

apt-add-repository

apt update

# check if java is installed and install if needed

if [ $(dpkg-query -W -f='${Status}' openjdk-17-jre-headless 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install -y openjdk-17-jre-headless;
fi

cd /home/minecraft

echo "downloading minecraft server file..."

sudo su

curl https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar > minecraft_server.1.18.1.jar

echo "starting server for first time..."

java -Xms1G -Xmx7G -jar minecraft_server.1.18.1.jar nogui

# sign EULA

echo "signing EULA..."

sed -i 's/false/true/g' eula.xt

echo "starting Minecraft Server..."

screen -S mcs java -Xms1G -Xmx7G -jar minecraft_server.1.18.1.jar nogui

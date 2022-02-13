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
	echo "mouting disk..."
        mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft	
else 
	echo "disk is already partitioned";
fi

# Install and run the Minecraft server

apt update
apt-get install -y default-jre-headless 	#installing dependencies





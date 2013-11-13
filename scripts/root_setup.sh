#!/bin/bash

set -e

# Updating and Upgrading dependencies
sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null

# Install necessary libraries for guest additions and Vagrant NFS Share
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common

# Install necessary dependencies
sudo apt-get -y -q install curl wget

# Setup sudo to allow no-password sudo for "vagrant"
OLD_VAGRANT_GID=`id -g vagrant`
echo "Vagrant group id:"
echo $OLD_VAGRANT_GID
VAGRANT_ID=`id -u vagrant`
echo "Vagrant user has id:"
echo $VAGRANT_ID

#groupmod -g 990 vagrant
#find / -gid $OLD_VAGRANT_GID -exec chgrp -h 990 '{}' \+

usermod -a -G vagrant vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=vagrant' /etc/sudoers
sed -i -e 's/%vagrant ALL=(ALL) ALL/%vagrant ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install guest additions
mount -o loop /home/vagrant/VBoxGuestAdditions_4.3.0.iso /media/cdrom
sh /media/cdrom/VBoxLinuxAdditions.run || true
umount /media/cdrom

# Install Puppet
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get -y install puppet-common=3.3.0-1puppetlabs1
apt-get -y install puppet=3.3.0-1puppetlabs1

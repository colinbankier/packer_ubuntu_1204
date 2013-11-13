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
groupadd -r -g 990 vagrant
usermod -a -G vagrant -u 990 vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=vagrant' /etc/sudoers
sed -i -e 's/%vagrant ALL=(ALL) ALL/%vagrant ALL=NOPASSWD:ALL/g' /etc/sudoers

# Install Puppet
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get -y install puppet-common=3.3.0-1puppetlabs1
apt-get -y install puppet=3.3.0-1puppetlabs1

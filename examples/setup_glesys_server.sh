#! /bin/sh
#
# Very basic bootstrap install script for Debian GNU/Linux.
# You should extend this script to install appropriate settings
# for your site into puppet.conf

set -e
apt-get -qy update
apt-get -qy install puppet
echo START=yes >> /etc/default/puppet
service puppet start

# allow some time to allow the CSR to arrive at the master
sleep 10

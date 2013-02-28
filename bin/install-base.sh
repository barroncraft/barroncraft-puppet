#!/bin/sh

apt-get update
apt-get upgrade -y
apt-get install -y puppet git-core
rm -rf /etc/puppet; mkdir /etc/puppet
git clone git://github.com/barroncraft/barroncraft-puppet.git /etc/puppet
puppet /etc/puppet/manifests/baseSetup.pp
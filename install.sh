#!/bin/sh

apt-get update
apt-get upgrade
apt-get install puppet git-core
rm -rf /etc/puppet/*
git clone git://github.com/Nullreff/minecraft-puppet.git /etc/puppet
puppet apply /etc/puppet/manifests/setup.pp

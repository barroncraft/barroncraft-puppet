#!/bin/sh

apt-get update
apt-get upgrade -y
apt-get install -y puppet git-core
rm -rf /etc/puppet/*
git clone git://github.com/Nullreff/minecraft-puppet.git /etc/puppet
puppet /etc/puppet/manifests/baseSetup.pp

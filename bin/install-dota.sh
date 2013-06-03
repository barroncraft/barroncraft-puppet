#!/bin/sh

if [ -f /etc/debian_version ]; then
    if ! grep '7\.' /etc/debian_version >/dev/null; then
        echo "Unsuported Debian version, please use 7.x."
        exit 1
    fi
    echo "Detected Debian system, installing..."
    apt-get update
    apt-get upgrade -y
    apt-get install -y puppet git

elif [ -f /etc/redhat-release ]; then
    if ! grep ' 6\.' /etc/redhat-release >/dev/null; then
        echo "Unsuported CentOS/RedHat version, please use 6.x."
        exit 1
    fi
    echo "Detected CentOS/RedHat system, installing..."

    # Add RPM Forge source
    rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
    rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.`uname -i`.rpm

    # Add Puppet source
    rpm -i http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-6.noarch.rpm

    # Update all packages and install puppet and git
    yum update -y
    yum upgrade -y
    yum install -y puppet git
else
    echo 'Unsuported operating system.  Email contact@barroncraft.com if you need help.'
    exit 1
fi

rm -rf /etc/puppet; mkdir /etc/puppet
git clone git://github.com/barroncraft/barroncraft-puppet.git /etc/puppet
puppet apply /etc/puppet/manifests/dotaSetup.pp

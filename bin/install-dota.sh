#!/bin/sh

if [ -f /etc/debian_version ]; then
    echo "Detected Debian system, installing..."
    apt-get update
    apt-get upgrade -y
    apt-get install -y puppet git-core
elif [ -f /etc/redhat-release ]; then
    if grep ' 5\.' /etc/redhat-release >/dev/null; then
        RELEASE='5'
    elif grep ' 6\.' /etc/redhat-release >/dev/null; then
        RELEASE='6'
    else
        echo "Unsuported CentOS/RedHat version, please use 5.x or 6.x."
        exit 1
    fi
    echo "Detected CentOS/RedHat system, installing..."
    rpm -i http://yum.puppetlabs.com/el/$RELEASE/products/i386/puppetlabs-release-$RELEASE-6.noarch.rpm
    yum update -y
    yum upgrade -y
    yum install -y puppet git
else
    echo 'Unsuported operating system.  Email contact@barroncraft.com if you need help.'
fi

rm -rf /etc/puppet; mkdir /etc/puppet
git clone git://github.com/barroncraft/barroncraft-puppet.git /etc/puppet
puppet apply /etc/puppet/manifests/dotaSetup.pp

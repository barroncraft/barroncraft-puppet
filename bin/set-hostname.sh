#!/bin/bash
# Sets the hostname for a SmartOS node to its reverse lookup hostname

IP=`ifconfig | grep -m 1 'inet addr' | awk '{print $2}' | sed 's/addr://g'`
NAME=`host $IP | sed 's/.* //' | sed 's/\.$//'`
echo $NAME > /etc/hostname
sed -i 's/localhost\.localdomain/$NAME/' /etc/hosts
/etc/init.d/hostname.sh start

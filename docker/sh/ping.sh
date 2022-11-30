#!/bin/bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo 'deb http://mirrors.163.com/debian/ stretch main non-free contrib' > /etc/apt/sources.list
echo 'deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib' >> /etc/apt/sources.list
echo 'deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib' >> /etc/apt/sources.list
apt-get -y upgrade
apt-get -y update
apt-get -y install iputils-ping 
touch /sh/test 
ping -c 10 b1xcy > /sh/test
tail -f /dev/null

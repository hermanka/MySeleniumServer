#!/bin/sh

yum -qq update
yum -y install java-1.8.0-openjdk-devel
yum -y install firefox Xvfb libXfont Xorg
yum -y groupinstall "X Window System" "Desktop" "Fonts" "General Purpose Desktop"

# install gecko driver
mkdir /usr/lib/geckodriver
cd /usr/lib/geckodriver
wget https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz
tar -xzf geckodriver-v0.19.1-linux64.tar.gz


# setup xvfb to auto start
sed -i -e '$i \Xvfb :99 -ac -screen 0 1024x768x8 > /tmp/xvfb.log 2>&1 &\n' /etc/rc.local

# install selenium
mkdir /usr/lib/selenium
cd /usr/lib/selenium
curl -sO http://selenium-release.storage.googleapis.com/3.10/selenium-server-standalone-3.10.0.jar
ln -s selenium-server-standalone-3.10.0.jar selenium-server-standalone.jar
chmod a+x selenium-server-standalone.jar
mkdir -p /var/log/selenium
chmod a+w /var/log/selenium
curl -s https://gist.githubusercontent.com/adeubank/2d92d66caff2727ce1cc/raw/f94e62fb257e9220b7934724dc89d6763876a07c/selenium > /etc/init.d/selenium
chmod 755 /etc/init.d/selenium
chkconfig selenium

# start xvfb
Xvfb :99 -ac -screen 0 1024x768x8 > /tmp/xvfb.log 2>&1 &

# start selenium
service selenium start
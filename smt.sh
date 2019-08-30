#!/bin/bash

function checkPackage () {
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $package|grep "install ok installed")
echo Checking for $package: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No $package. Setting up $package."
  sudo apt -y install $package
fi
}

function isRoot () {
	if [ "$EUID" -ne 0 ]; then
		return 1
	fi
}
function initalRun () {
	if ! isRoot; then
		echo "Sorry, you need to run this as root"
		exit 1
	fi
}

initalRun

echo "Update apt"
echo "--------------------------------------------"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' apt|grep "install ok installed")
echo Checking for apt: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No apt installed. "
  exit 1
fi


apt -y update

echo "Upgrade apt"
echo "--------------------------------------------"

apt -y upgrade

echo "Checking for base package"
echo "--------------------------------------------"

package="nano"
checkPackage
package="htop"
checkPackage
package="nload"
checkPackage
package="wget"
checkPackage
package="curl"
checkPackage
package="zip"
checkPackage
package="unzip"
checkPackage

echo "Activating numpad on nano"
echo "--------------------------------------------"
echo "set rebindkeypad" >> /etc/nanorc

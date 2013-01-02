#!/bin/bash
#
# ownCloud
#
# @author Thomas Müller
# @copyright 2012 Thomas Müller thomas.mueller@tmit.eu
#

# Ensure wir are in the correct folder
cd `dirname $0`

#
# Load rvm from home or system
#
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
elif [ -f "/usr/local/rvm/scripts/rvm" ]; then
  source "/usr/local/rvm/scripts/rvm"
else
  echo "Can not load rvm"
  exit 1
fi

#
# Set the gemset and ruby version
#
rvm use ruby-1.9.3@oc_acceptance --create

# let's assume bundler is installed
#gem install bundler
bundle install

#
# We need xvfb and virtual box. Check if these executables are in $PATH
#
if [ ! `which xvfb-run` ]; then
  echo "You have to install xvfb in order to run the test suite"
  exit 1
fi
if [ ! `which vboxmanage` ]; then
  echo "You have to install virtualbox in order to run the test suite"
  exit 1
fi

function run_tests {
	VM_NAME=$1
	IP=$2

	#
	# first start the vm(s)
	#
	cd Vagrant
	vagrant up $VM_NAME
	#vagrant up master_on_lighttpd

	#
	# fire the bdd test suite
	#
	cd ..
	rm -rf logs/$VM_NAME
	mkdir -p logs
	bundle exec cucumber -f json -o ./logs/$VM_NAME.json HOST=$IP features

	#
	# webdav tests
	#
	if [ ! `which litmus` ]; then
	  echo "You have to install litmus in order to run the webdav test suite(http://www.webdav.org/neon/litmus/)"
	else
	  litmus -k http://$IP/remote.php/webdav/ admin admin
	fi

	#
	# bring down the vm
	#
	cd Vagrant
	vagrant halt $VM_NAME
	#vagrant halt master_on_lighttpd
}


run_tests master_on_apache_with_sqlite 33.33.33.10
run_tests master_on_apache_with_mysql 33.33.33.11

#
# Say good bye
#
echo " "
echo "Done. Thank you for testing ownCloud!"

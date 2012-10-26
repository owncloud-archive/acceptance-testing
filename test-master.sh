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
rvm use ruby-1.9.3-p194@oc_acceptance --create

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
if [ ! `which virtualbox` ]; then
  echo "You have to install virtualbox in order to run the test suite"
  exit 1
fi

#
# first start the vm(s)
#
cd Vagrant
vagrant up master_on_apache
#vagrant up master_on_lighttpd

#
# fire the bdd test suite
#
cd ..
rm -rf logs
mkdir logs
bundle exec cucumber -f json -o ./logs/apache.json HOST=33.33.33.10 features
#bundle exec cucumber HOST=33.33.34.10 features

#
# bring down the vm
#
cd Vagrant
vagrant halt master_on_apache
#vagrant halt master_on_lighttpd

#
# Say good bye
#
echo " "
echo "Done. Thank you for testing ownCloud!"

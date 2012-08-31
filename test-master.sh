#!/bin/bash
#
# ownCloud
#
# @author Thomas Müller
# @copyright 2012 Thomas Müller thomas.mueller@tmit.eu
#

#
# first start the vm(s)
#
cd Vagrant
vagrant up master_on_apache
#vagrant up master_on_lighttpd

#
# setup cucumber - I use rvm here
#
source "$HOME/.rvm/scripts/rvm"
rvm ruby-1.9.2-p290
rvm gemset use oc_acceptance

# let's assume bundler is installed
#gem install bundler
bundle install

#
# fire the bdd test suite
#
cd ..
bundle exec cucumber -f json -o ./logs/apache HOST=33.33.33.10 features
#bundle exec cucumber HOST=33.33.34.10 features

#
# bring down the vm
#
cd Vagrant
#vagrant halt master_on_apache
#vagrant up master_on_lighttpd


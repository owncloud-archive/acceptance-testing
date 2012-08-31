#!/bin/bash
#
# ownCloud
#
# @author Thomas Müller
# @copyright 2012 Thomas Müller thomas.mueller@tmit.eu
#

#
# setup
#
gem install bundler
bundle install

#
# first start the vm(s)
#
cd Vagrant
vagrant up master_on_apache
#vagrant up master_on_lighttpd

#
# fire the bdd test suite
#
bundle exec cucumber HOST=33.33.33.10 features
#bundle exec cucumber HOST=33.33.34.10 features



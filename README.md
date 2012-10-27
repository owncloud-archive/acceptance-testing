#Acceptance Testing For OwnCloud

This repository contains two major components:

* Cucumber features for acceptance testing

* Within Vagrant modules and manifests are located to startup various versions 
  of ownCloud on various systems

##Preparing your system for running tests


For running the acceptance tests you have to setup rvm [1] and ruby. We 
recommend installing rvm in your homedirectory, but we support installing rvm 
system wide as well.

After installing rvm, you have to install ruby 1.9.3

    $ rvm install 1.9.3

To run the tests with vagrant you have to install virtualbox and xvfb.

[1]: https://rvm.io

##Running tests in your test environment

After cloning or updating this repository run

    $ bundle install

to ensure that all required gems are installed.

To execute the tests run

    $ cucumber HOST=$host features

Replace $host with the address of your test environment.

Cucumber expects to find the following environment:

1. A clone of owncloud-core

1. An admin account with the name "admin" and the password "admin"

1. An user account with the name "user1" and the password "user1"

1. An user account with the name "user2" and the password "user2" 

1. An user account with the name "user3" and the password "user3" 

1. Users "user1" and "user2" are member of "group1"

##Running tests with vagrant

To run the tests on as many environments as possible, you should use vagrant by 
simply executing

    $ ./test-master.sh

Vagrant creates virtual machines with different setups (regarding webserver, 
browser, database backend, user backend) and runs the tests on them.

##Writing new features

Writing user stories is really easy. Just have a look at the existing stories in /features and change them according to your needs.

#Note on Patches/Pull Requests

* Fork the project.

* Make your feature addition or bug fix.

* Test your changes.

* Send a merge request.

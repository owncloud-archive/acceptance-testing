#Acceptance Testing For OwnCloud

This repository contains two major components:

* Cucumber features for acceptance testing

* Within Vagrant cookbooks are located to startup various versions of ownCloud
  on various systems

#Preparing your system


For running the acceptance tests you have to setup rvm [1] and ruby. We
recommend installing rvm in your homedirectory, but we support installing rvm
system wide as well.

After installing rvm, you have to install ruby 1.9.3

    $ rvm install 1.9.3

To run the tests with vagrant you have to install virtualbox and xvfb.

[1]: https://rvm.io

# Running tests

## Running tests on your own system

To keep the ownCloud repositories stable you should always test your code
before pushing it. To ensure that your changes do not affect the rest of
ownCloud you should run the accesptance test suite against your code on a
regular base.

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

#Extending the test suite

Having a test suite is cool, but without constantly updating it the test suite 
becomes useless over time.

There are several ways to help us improving the test suite.

##Writing new features

Writing user stories is really easy. Just have a look at the existing stories
in /features and change them according to your needs.

##Adapting features to changes in the UI

When an old test fails, there are several possible reasons.

* Someone introduced a bug: Write a bug report in the correct repository.

* The UI changed slightly: Find out what changed and update the user story

* The UI has been redesigned: Consider rewriting all tests regarding this
  feature

* The feature has been removed: remove the features.

##Improving the Vagrant setup

You can easily add more setups to vagrant. We use chef solo for provisioning.
All cookbooks in /Vagrant/cookbooks except the owncloud cookbook are copied 
from [2]. You find instructions on installing additional cookbooks in
/Vagrant/cookbooks/README.md .

When adding a new virtual machine please use the following naming schema:

    ${branch}_on_${webserver}_with_${database}[_using_${whatever}]*

where the last point refers to special setups like the user backends, group
backends or file systems.

If you extend the cookbook please keep the following things in mind:

* add new attributes to both attributes/default.rb and metadata.rb

* every test run should start with a clean environment (no files, users and
  groups as defined earlier).

* chef\_solo uses ruby 1.8 on the client side

* The code should be well readable

[2]: http://community.opscode.com/cookbooks

#Note on Patches/Pull Requests

* Fork the project.

* Make your feature addition or bug fix.

* Test your changes.

* Send a merge request.

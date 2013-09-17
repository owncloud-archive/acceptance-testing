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

Replace $host (e.g. cucumber HOST=localhost:8888/ownCloud/ features) with the address of your test environment.

Run single feature:

    $ cucumber features/files.feature

Run single scenario:

    $ cucumber features/files.feature:14

This runs the scenario in line 14.

Cucumber expects to find the following environment:

1. A clone of owncloud-core

1. An admin account with the name "admin" and the password "admin"

1. An user account with the name "user1" and the password "user1"

1. An user account with the name "user2" and the password "user2"

1. An user account with the name "user3" and the password "user3"

1. Users "user1" and "user2" are member of "group1"

To execute the tests with webkit (default is executed with firefox):

    $ cucumber HOST=$host BROWSER='webkit' features
    
To execute the tests headless (default is non-headless):

    $ cucumber HOST=$host HEADLESS=true features

##Running tests with vagrant

To run the tests against the latest ownCloud master on as many environments
as possible, you should use vagrant by simply executing

    $ ./test-master.sh

Vagrant creates virtual machines with different setups (regarding webserver,
browser, database backend, user backend) and runs the tests on them.

You can set up vitual machines using your local ownCloud repository. To do so
you must copy your core repository to Vagrant/localsrc/core. Repeat this for
apps and 3rdparty. Please note that it is not possible to use symlinks here.

After copying the files you can start the virtual machine by executing

    $ vagrant up local_on_apache_with_sqlite

in the Vagrant folder. Once the machine is up you can run the cucumber against
33.99.33.10.

Additionally, this test suite ships a script called *run-tests.rb*. It allows
you to manage the vms very easily. run-tests has the following options:

    --branch BRANCH       Only test the given branch. If a list is given any
                          vm that loads one of these branches will be loaded
    --server SERVER       Only test ownCloud on the given webserver. If a list
                          is given any vm that uses one of these servers will
                          be loaded
    --database DATABASE   Only test ownCloud with the given database. If a list
                          is given any vm that uses one of these servers will
                          be loaded
    --feature FEATURE     Only use vms that have a certain feature. If a list
                          is given only vms that support all of these features
                          will be loaded
    --action ACTION       Can be one or more of list, up, provision, halt,
                          suite, testdav, cucumber
                          Default: list

Don't use spaces when passing a list.

*Example:* Run litmus on all vms that use apache or nginx as a web server and
use sqlite as database.

    $ ruby run-tests.rb -s apache,nginx -d sqlite -a up,litmus,halt

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

#Known Issues

###Selenium-webdriver not working with most recent Firefox version

Error if you run the cucumber tests:
“unable to obtain stable firefox connection in 60 seconds”

Probably the selenium-webdriver isnt working with a new Firefox Version.

To fix try:

      $ gem update selenium-webdriver
      
      $ bundle update selenium-webdriver
      
If its working, update the version in the Gemfile

###Vagrant missing berkshelf or omnibus

Error if you try to bring up the vagrant box:
Vagrant: * Unknown configuration section 'berkshelf'.

You are missing the vagrant-berkshelf or vagrant-omnibus plugin:

       $ vagrant plugin install vagrant-berkshelf
       $ vagrant plugin install vagrant-omnibus

###capybara-webkit needs qt

Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.
Command 'qmake -spec macx-g++' not available

You are missing the qt files:

On a mac with homebrew you can do:

      $ brew install qt

#Note on Patches/Pull Requests

* Fork the project.

* Make your feature addition or bug fix.

* Test your changes.

* Send a merge request.

Setup:
1. install vagrant:
   apt-get install vagrant

2. get owncloud tar ball (for now this works only on master)
   wget https://gitorious.org/owncloud/owncloud/archive-tarball/master

3. start up vagrant
   vagrant up oc_on_apache

4. open browser to http://33.33.33.10/ to see a running oc instance on apache01

TODO:
 - setup nginx
 - setup lighttpd
 - execute test suite
 - first write the test suite
   


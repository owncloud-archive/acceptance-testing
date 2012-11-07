#!/bin/bash
#
# ownCloud
#
# @author Thomas Mueller
# @copyright 2012 Thomas Müller thomas.mueller@tmit.eu
#
cd /tmp
wget https://github.com/owncloud/3rdparty/archive/master.tar.gz
mv master.tar.gz 3rdparty.tar.gz
wget https://github.com/owncloud/core/archive/master.tar.gz
mv master.tar.gz core.tar.gz

# we perform root installation into /var/www
cd /var/www/
rm -rf *
tar -C /tmp -xzf /tmp/core.tar.gz
mv /tmp/core-master/* .
tar -C /tmp -xzf /tmp/3rdparty.tar.gz
mkdir -p /var/www/3rdparty
mv /tmp/3rdparty-master/* 3rdparty

# basic setup
mkdir data
chown www-data:www-data config data apps

# create autoconfig for sqlite
cat > /var/www/config/autoconfig.php <<DELIM
<?php
\$AUTOCONFIG = array (
  'installed' => false,
  'dbtype' => 'sqlite',
  'dbtableprefix' => 'oc_',
  'adminlogin' => 'admin',
  'adminpass' => 'admin',
  'directory' => '/var/www/data/',
  'loglevel' => '0',
);
DELIM

# trigger installation
wget http://localhost/
#wget http://33.33.33.10/


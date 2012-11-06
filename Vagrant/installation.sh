#!/bin/bash
#
# ownCloud
#
# @author Thomas Mueller
# @copyright 2012 Thomas Müller thomas.mueller@tmit.eu
#
TARBALL=$1

# we perform root installation into /var/www
cd /var/www/
rm -rf *
tar -C /tmp -xzf $TARBALL
mv /tmp/owncloud/* .

# basic setup
mkdir data
chown -R www-data:www-data config data apps

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


#
# Cookbook Name:: owncloud
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#==============================================================================
# TOC:
#   0: define database connections etc.
#   1: install required packages
#   2: clean up old configuration
#   3: copy new files
#   4: install ownCloud
#   5: create the environment defined in Readme.md
#------------------------------------------------------------------------------
# 0: define database connections etc.
#==============================================================================

mysql_connection_info = { :host => "localhost",
                          :username => 'root',
                          :password => node['mysql']['server_root_password']}
postgresql_connection_info = { :host => "localhost",
                               :username => 'postgres',
                               :password => node['postgresql']['password']['postgres']}

#==============================================================================
# 1: install required packages
#==============================================================================
# Update package cache
include_recipe "apt"
include_recipe "git"

# Add wget (for installing)
package "wget" do
  action [:install]
end

case node[:owncloud][:setup][:webserver]
when "apache2"
  include_recipe "apache2"
  include_recipe "apache2::mod_php5"

  apache_site "default"

  service "apache2" do
    action :restart
  end
else
  # FIXME: report error
end

include_recipe "php"
include_recipe "php::module_gd"

# Database & connector
case node[:owncloud][:config][:dbtype]
when "sqlite"
  include_recipe "php::module_sqlite3"
when "mysql"
  # Install mysql
  include_recipe "mysql::server"
  include_recipe "mysql::client"
  include_recipe "php::module_mysql"
  include_recipe "database::mysql"

  # drop old database and user
  mysql_database "owncloud" do
    connection mysql_connection_info
    action :drop
  end
  mysql_database_user "owncloud" do
    connection mysql_connection_info
    action :drop
  end

  # create new database
  mysql_database "owncloud" do
    connection mysql_connection_info
    action :create
  end

  # create owncloud user and give rights to do everything
  mysql_database_user "owncloud" do
    connection mysql_connection_info
    password "owncloud"
    action :create
  end
  mysql_database_user "owncloud" do
    connection mysql_connection_info
    password "owncloud"
    database_name "owncloud"
    action :grant
  end
when "pgsql"
  # Install postgresql
  include_recipe "postgresql::server"
  include_recipe "postgresql::client"
  include_recipe "php::module_pgsql"
  include_recipe "database::postgresql"

  # drop old database and user
  postgresql_database "owncloud" do
    connection postgresql_connection_info
    action :drop
  end
  postgresql_database_user "owncloud" do
    connection postgresql_connection_info
    action :drop
  end

  # create new database
  postgresql_database "owncloud" do
    connection postgresql_connection_info
    action :create
  end

  # create owncloud user and give rights to do everything
  postgresql_database_user "owncloud" do
    connection postgresql_connection_info
    password "owncloud"
    action :create
  end
  postgresql_database_user "owncloud" do
    connection postgresql_connection_info
    password "owncloud"
    database_name "owncloud"
    action :grant
  end
else
  # FIXME: report error!
end

# TODO; install additional software
# Software for user backends?
# IMAP-Server, FTP-Server, another WebDAV-Server, LDAP?

#==============================================================================
# 2: clean up old configuration
#==============================================================================
directory "/var/www/" do
  action :delete
  recursive true
  only_if { File.exists? "/var/www/" }
end

directory "/var/www" do
  action :create
  group "www-data"
  mode 0775
  not_if { File.exists? "/var/www/" }
end

#==============================================================================
# 3: copy new files
#==============================================================================

# clone repositories
directory "/usr/local/src" do
  action :create
  recursive true
end

git "/usr/local/src/owncloud-core" do
  repository "git://github.com/owncloud/core.git"
  reference node[:owncloud][:setup][:branch]
  action :sync
end

git "/usr/local/src/owncloud-apps" do
  repository "git://github.com/owncloud/apps.git"
  reference node[:owncloud][:setup][:branch]
  action :sync
end

git "/usr/local/src/owncloud-3rdparty" do
  repository "git://github.com/owncloud/3rdparty.git"
  reference node[:owncloud][:setup][:branch]
  action :sync
end

# Copy files
execute "Copy core files" do
  command "cp -ar /usr/local/src/owncloud-core/* /var/www/"
end

execute "Copy 3rdparty folder" do
  command "cp -ar /usr/local/src/owncloud-3rdparty /var/www/3rdparty"
end

# TODO: copy apps





#==============================================================================
# 4: install ownCloud
#==============================================================================

# create data dir, set rights of apps and config dir
directory "/var/www/data" do
  action :create
  mode 0755
  owner "www-data"
  group "www-data"
end

execute "Chowning apps and config" do
  command "chgrp www-data /var/www/apps /var/www/config"
end

execute "Chmodding apps and config" do
  command "chmod g+w /var/www/apps /var/www/config"
end

# create autoconf.php and a backup
template "/var/www/config/autoconfig.php" do
  source "autoconfig.php.erb"
  variables :config_data => node[:owncloud][:config]
  mode 0644
end
template "/var/www/config/autoconfig.backup.php" do
  source "autoconfig.php.erb"
  variables :config_data => node[:owncloud][:config]
  mode 0644
end

# install owncloud
http_request "install ownCloud" do
  url "http://localhost/"
  message Hash.new
end

#==============================================================================
# 5: Create the environment
#==============================================================================

# TODO: use system calls or ownCloud provisioning API to create the environment.


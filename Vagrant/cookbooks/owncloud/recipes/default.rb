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
#   1: create the environment (without ownCloud)
#   2: set up web server
#   3: clean up old configuration
#   4: copy new files
#   5: install ownCloud
#   6: create the environment defined in Readme.md
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
# 1: create the environment (without ownCloud)
#==============================================================================
# Update package cache
include_recipe "apt"
include_recipe "git"

package "curl" do
  action [:install]
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

# Set up software that is required for user authentication etc.
case node[:owncloud][:setup][:user_backend]
when "ldap"
  # TODO: install ldap, prepare everything
  # The cookbooks "openldap" and "ldapknife" might help

  # Don't forget to create admin, user{1-3} as defined in README.md
end

#==============================================================================
# 2: set up web server
#==============================================================================
case node[:owncloud][:setup][:webserver]
when "apache2"
  include_recipe "apache2"
  include_recipe "apache2::mod_php5"

  apache_site "default"

  service "apache2" do
    action :restart
  end
when "nginx"
  include_recipe "nginx"
  package "php5-fpm" do
    action [:install]
  end
  package "nginx-extras" do
    action [:install]
  end

  template "#{node['nginx']['dir']}/sites-available/default" do
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :reload, 'service[nginx]'
  end

  service "nginx" do
    action :restart
  end
when "lighttpd"
  package "lighttpd" do
    action [:install]
  end

  template "/etc/lighttpd/conf-available/20-owncloud.conf" do
    source "lighttpd.conf.erb"
    owner "root"
    group "root"
    mode 00644
  end

  execute "enable ownCloud page in lighttpd" do
    command "lighttpd-enable-mod owncloud fastcgi"
  end
  execute "restart lighttpd" do
    command "service lighttpd restart"
  end
else
  # FIXME: report error
end

#==============================================================================
# 3: clean up old configuration
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
# 4: copy new files
#==============================================================================

case node[:owncloud][:setup][:source]
when "local"
  # Copy files
  execute "copy core folder" do
    command "cp -Lpr /vagrant/localsrc/core/* /var/www"
  end

  execute "Link apps folder" do
    command "cp -Lpr /vagrant/localsrc/apps /var/www/apps2"
  end

  execute "Link core folder" do
    command "cp -Lpr /vagrant/localsrc/3rdparty /var/www/3rdparty"
  end
else
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

  execute "Copy apps folder" do
    command "cp -ar /usr/local/src/owncloud-apps /var/www/apps2"
  end
end

# Save version of apps, core and 3rdparty in /var/www/version.txt
template "/usr/local/bin/copy_versions.sh" do
  source "copy_versions.sh.erb"
  variables :setup_data => node[:owncloud][:setup]
  mode 0755
end
execute "Writing /var/www/versions.txt" do
  command "/usr/local/bin/copy_versions.sh"
end

#==============================================================================
# 5: install ownCloud
#==============================================================================

# create data dir, set rights of apps and config dir
directory "/var/www/data" do
  action :create
  mode 0755
  owner "www-data"
  group "www-data"
end

directory "/var/www/apps3" do
  action :create
  mode 0755
  owner "www-data"
  group "www-data"
end

execute "Chowning apps and config" do
  command "chgrp www-data /var/www/config"
end

execute "Chmodding apps and config" do
  command "chmod g+w /var/www/config"
end

# create autoconf.php and a backup
template "/var/www/config/autoconfig.php" do
  source "autoconfig.php.erb"
  variables :config_data => node[:owncloud][:config]
  owner "www-data"
  group "www-data"
  mode 0644
end
template "/var/www/config/autoconfig.backup.php" do
  source "autoconfig.php.erb"
  variables :config_data => node[:owncloud][:config]
  owner "www-data"
  group "www-data"
  mode 0644
end

# create autoconf.php and a backup
template "/var/www/config/config.php" do
  source "config.php.erb"
  variables :setup_data => node[:owncloud][:setup]
  owner "www-data"
  group "www-data"
  mode 0644
end
template "/var/www/config/config.backup.php" do
  source "config.php.erb"
  variables :setup_data => node[:owncloud][:setup]
  owner "www-data"
  group "www-data"
  mode 0644
end

# install owncloud
http_request "install ownCloud" do
  url "http://localhost/"
  message Hash.new
end

#==============================================================================
# 6: Create the environment (with ownCloud)
#==============================================================================

case node[:owncloud][:setup][:user_backend]
when "database"
  # enable provisioning API
  template "/var/www/enable_provisioning_api.php" do
    source "enable_provisioning_api.php.erb"
    variables Hash.new
    owner "www-data"
    group "www-data"
    mode 0644
  end
  http_request "enabling provisioning_api" do
    url "http://localhost/enable_provisioning_api.php"
    message :some => "value" # Hash.new
  end
  file "var/www/enable_provisioning_api.php" do
    action :delete
  end

  # Create users
  (1..3).each do |i|
    execute "Creating user#{i}" do
      command "curl -X POST -u admin:admin -d \"userid=user#{i}&" +
              "password=user#{i}\" localhost/ocs/v1.php/cloud/users"
    end
  end

  # Create group
  execute "Creating group1" do
    command "curl -X POST -u admin:admin -d \"groupid=group1\"" +
            " localhost/ocs/v1.php/cloud/groups"
  end

  # Put user1 and user2 in group1
  (1..2).each do |i|
    execute "Putting user#{i} in group1" do
      command "curl -X POST -u admin:admin -d \"groupid=group1&\"" +
              " localhost/ocs/v1.php/cloud/users/user#{i}/groups"
    end
  end
end

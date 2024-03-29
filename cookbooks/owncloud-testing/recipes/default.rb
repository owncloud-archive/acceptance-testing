#
# Cookbook Name:: owncloud-testing
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# Define small helper method here - find better place soon
def local_ruby_version
  if File.exist? "/vagrant/.ruby-version"
    File.read( "/vagrant/.ruby-version" ).chomp
  else
    "1.9.3-p194"
  end
end

# Install owncloud using the official community cookbook
include_recipe "owncloud"

# (re-) create a well defined environment
template "/var/www/owncloud/reset-environment.php" do
    source "reset-environment.php.erb"
    variables Hash.new
    owner "www-data"
    group "www-data"
    mode 0644
end

http_request "reset-environment.php" do
    url "http://localhost/reset-environment.php"
end

# Install software we need for testing
include_recipe "apt"
%w(xvfb qt4-qmake libqtwebkit-dev).each do |pkg|
  package pkg do
    action :install
  end
end

# Install ruby 1.9.3-p194 and bundler
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby local_ruby_version
rbenv_gem "bundler" do
  # TODO: use "ruby_version lazy { local_ruby_version }" as soon as chef 11.6 is used
  ruby_version "1.9.3-p429" # lazy { local_ruby_version }
end

# Install the required gems (like cucumber, selenium etc.)
execute "installing required gems" do
  command "bundle install"
  cwd "/vagrant"
  action :run
end

# Install litmus
remote_file "download litmus" do
  source "http://www.webdav.org/neon/litmus/litmus-0.13.tar.gz"
  path "/tmp/litmus-0.13.tar.gz"
  action :create
  notifies :run, "execute[extract litmus]", :immediately
  not_if { File.exists? "/usr/local/bin/litmus" }
end

execute "extract litmus" do
  command "tar xzf litmus-0.13.tar.gz"
  action :nothing
  cwd "/tmp"
  notifies :run, "execute[install litmus]", :immediately
end

execute "install litmus" do
  command "./configure && make && make install"
  cwd "/tmp/litmus-0.13"
  action :nothing
end

group "rbenv" do
  action :modify
  append true
  members "vagrant"
end

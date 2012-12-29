#
# Cookbook Name:: owncloud
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "wget" do
  action [:install]
end

unless File.exists? "/tmp/owncloud-autoconfig"
  execute "mkdir /tmp/owncloud-autoconfig" do
    command "mkdir /tmp/owncloud-autoconfig"
  end
  template "/tmp/owncloud-autoconfig/base.conf" do
    source "base.conf.erb"
  end
  template "/tmp/owncloud-autoconfig/dbtype.conf" do
    source "dbtype.conf.erb"
    variables :dbtype => node[:owncloud][:dbtype]
  end
end

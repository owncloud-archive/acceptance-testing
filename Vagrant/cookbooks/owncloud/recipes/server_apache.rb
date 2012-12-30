#
# Cookbook Name:: owncloud
# Recipe:: install
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "owncloud"

# restart apache
execute "service apache2 restart" do
  command "service apache2 restart"
end

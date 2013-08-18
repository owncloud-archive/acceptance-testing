#
# Cookbook Name:: owncloud-testing
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "owncloud"

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

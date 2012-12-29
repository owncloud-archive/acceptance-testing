maintainer       "Jakob Sack"
maintainer_email "jakob@owncloud.org"
license          "All rights reserved"
description      "Installs/Configures owncloud"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe            "owncloud", "prepares owncloud installation"
recipe            "owncloud::install", "installs owncloud"

%w{debian ubuntu}.each do |os|
  supports os
end

attribute "owncloud",
  :display_name => "Owncloud Hash",
  :description => "Hash of ownCloud attributes",
  :type => "hash"

attribute "owncloud/branch",
  :display_name => "Owncloud branch",
  :description => "branch of ownCloud repo",
  :default => "master"

attribute "owncloud/config",
  :display_name => "Owncloud Hash",
  :description => "Hash of ownCloud configuration",
  :type => "hash"

attribute "owncloud/config/dbtype",
  :display_name => "Owncloud dbtype",
  :description => "which database should be used",
  :default => "sqlite"

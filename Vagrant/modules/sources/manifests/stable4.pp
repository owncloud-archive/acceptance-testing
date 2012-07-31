class oc_master_from_tarball {
  exec { "download-master-tarball":
    command => "/usr/bin/wget -P /temp/ https://gitorious.org/owncloud/owncloud/archive-tarball/stable4",
  }
  exec { "installation":
    command => "/usr/bin/sudo /vagrant/installation.sh /temp/owncloud-owncloud-stable4.tar.gz",
  }
}


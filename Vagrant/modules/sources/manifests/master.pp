class sources::master {
  include wget

  wget::fetch { "download-master-tarball":
    source => "https://gitorious.org/owncloud/owncloud/archive-tarball/master",
    destination => "/tmp/owncloud-owncloud-master.tar.gz",
    timeout => 0,
  }

  exec { "installation":
    command => "/usr/bin/sudo /bin/sh /vagrant/installation.sh /tmp/owncloud-owncloud-master.tar.gz",
    require => wget::fetch['download-master-tarball'],
  }
}


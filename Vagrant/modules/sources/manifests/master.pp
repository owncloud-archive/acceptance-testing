class sources::master {
  include wget

  wget::fetch { "download-tarball":
    source => "https://github.com/owncloud/core/archive/master.tar.gz",
    destination => "/tmp/owncloud-owncloud-master.tar.gz",
    timeout => 0,
  }

  exec { "installation":
    command => "/usr/bin/sudo /bin/sh /vagrant/installation.sh /tmp/owncloud-owncloud-master.tar.gz",
    require => wget::fetch['download-tarball'],
  }
}


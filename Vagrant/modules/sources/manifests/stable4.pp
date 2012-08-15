class sources::stable4 {
  include wget

  wget::fetch { "download-tarball":
    source => "https://gitorious.org/owncloud/owncloud/archive-tarball/stable4",
    destination => "/tmp/owncloud-owncloud-stable4.tar.gz",
    timeout => 0,
    require => Service['apache2'],
  }

  exec { "installation":
    command => "/usr/bin/sudo /bin/sh /vagrant/installation.sh /tmp/owncloud-owncloud-stable4.tar.gz",
    require => wget::fetch['download-tarball'],
  }
}


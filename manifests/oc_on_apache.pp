class apache_and_php {
  exec { "apt_update":
    command => "apt-get update",
    path    => "/usr/bin"
  }

  package { "php5":
    ensure => present,
  }

  package { "libapache2-mod-php5":
    ensure => present,
  }

  package { "apache2":
    ensure => present,
  }

  service { "apache2":
    ensure => running,
    require => Package["apache2"],
  }
}

class oc_depends {
  package { "php5-sqlite":
    ensure => present,
  }

  package { "php5-gd":
    ensure => present,
  }

  package { "wget":
    ensure => present,
  }
}

class oc_master_from_tarball {
  exec { "installation":
    command => "/usr/bin/sudo /vagrant/installation.sh",
  }
}

include apache_and_php
include oc_depends
include oc_master_from_tarball


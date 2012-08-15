class apache_and_php {
  exec { "apt_update":
    command => "apt-get update",
    path    => "/usr/bin"
  }

  file{
    "/etc/apache2/sites-enabled/000-default":
      mode => 755,
      owner => root,
      group => root,
      source => "/vagrant/modules/apache_and_php/configurations/default",
      notify => Service[apache2]
  }

  package { "php5":
    ensure => present,
  }

  package { "php5-xdebug":
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


  define apache::loadmodule () {
    exec { "/usr/sbin/a2enmod $name" :
      unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
      notify => Service[apache2]
    }
  }

  apache::loadmodule{"rewrite":}
}


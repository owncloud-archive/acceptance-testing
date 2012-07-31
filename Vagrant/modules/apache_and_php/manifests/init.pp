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

  define loadmodule () {
     exec { "/usr/sbin/a2enmod $name" :
          unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
          notify => Service[apache2]
     }
  }

  loadmodule("rewrite":)
}


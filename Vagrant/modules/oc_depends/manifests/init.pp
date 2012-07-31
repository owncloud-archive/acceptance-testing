class oc_depends {
  package { "php5-sqlite":
    ensure => present,
  }

  package { "php5-gd":
    ensure => present,
  }
}


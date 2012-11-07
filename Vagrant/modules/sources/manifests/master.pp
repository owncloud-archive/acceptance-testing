class sources::master {
  include wget

  exec { "installation":
    command => "/usr/bin/sudo /bin/sh /vagrant/install-master.sh",
  }
}


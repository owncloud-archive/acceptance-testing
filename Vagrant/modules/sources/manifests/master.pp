class sources::master {
  exec { "installation":
    command => "/usr/bin/sudo /bin/sh /vagrant/install-master.sh",
  }
}


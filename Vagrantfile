# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
 
  # base box and URL where to get it if not present
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
 
  # config for the apache box
  config.vm.define "oc_on_apache" do |app|
    app.vm.boot_mode = :gui
    app.vm.network :hostonly, "33.33.33.10"
    app.vm.host_name = "apache01.local"
    app.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.module_path  = "modules"
      puppet.manifest_file = "oc_on_apache.pp"
    end
  end
 
  # config for the lighttpd box
  config.vm.define "oc_on_lighttpd" do |db|
    db.vm.boot_mode = :gui
    db.vm.network :hostonly, "33.33.33.11"
    db.vm.host_name = "lighttpd01.local"
#    db.vm.provision :puppet do |puppet|
#      puppet.manifests_path = "manifests"
#      puppet.manifest_file = "dbserver.pp"
#    end
  end
 
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :notifier do |notifier_config|
    notifier_config.vm.host_name = "notifier"
    notifier_config.vm.network :hostonly, "192.168.2.10"
    notifier_config.vm.box = "precise64"
    notifier_config.vm.share_folder("v-root", "/vagrant", "./notifier", :extra => 'dmode=770,fmode=770')

    notifier_config.vm.forward_port 3000, 3000
    notifier_config.vm.forward_port 3001, 3001


    notifier_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path    = "puppet/modules"
      puppet.manifest_file  = "development.pp"
    end
  end
  config.vm.define :hub do |hub_config|
    hub_config.vm.host_name = "hub"
    hub_config.vm.network :hostonly, "192.168.2.11"
    hub_config.vm.box = "precise64"
    hub_config.vm.share_folder("v-root", "/vagrant", "./hub", :extra => 'dmode=770,fmode=770')

    hub_config.vm.forward_port 3000, 3002


    hub_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path    = "puppet/modules"
      puppet.manifest_file  = "development.pp"
    end
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_plugin "vagrant-butcher"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  # config.vm.network :private_network, ip: "192.168.33.10"
  # config.vm.network :public_network

  config.butcher.knife_config_file = :auto
  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "https://api.opscode.com/organizations/zynkmobile"
    chef.validation_key_path = "/Users/cassiano/Projects/chef-repos/zynk/.chef/zynkmobile-validator.pem"
    chef.validation_client_name = "zynkmobile-validator"
  end
end

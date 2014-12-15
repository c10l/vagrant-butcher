# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

orgname = ENV['CHEF_ORGNAME']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/ubuntu-14.04"
  # config.vm.network :private_network, ip: "192.168.33.10"
  # config.vm.network :public_network

  config.butcher.verify_ssl = true

  config.vm.provision :chef_client do |chef|
    chef.node_name = 'vagrant_butcher_test_vm'
    chef.chef_server_url = "https://api.opscode.com/organizations/#{orgname}"
    chef.validation_key_path = "~/.chef/#{orgname}-validator.pem"
    chef.validation_client_name = "#{orgname}-validator"
    # chef.run_list = [ 'recipe[dummy::fail]' ]
  end
end

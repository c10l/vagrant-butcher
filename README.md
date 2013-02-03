[![Gem Version](https://badge.fury.io/rb/vagrant-butcher.png)](http://badge.fury.io/rb/vagrant-butcher)

# Vagrant::Butcher

If you're using Vagrant with the Chef-Client provisioner, e.g. for creating cookbooks, it creates a client and a node on the Chef server. Once you destroy the VM, both the client and node will be kept on the server, which may cause problems if you fire up the same VM again.

This gem attempts to correct that.

## Installation

Installation will depend on whether you're using bundler or not.

### If you're using Bundler

Add this line to your cookbook's Gemfile:

    gem 'vagrant-butcher'

And then execute:

    $ bundle

### If you're not using bundler

You have to install this plugin via Vagrant:

    $ vagrant gem install 'vagrant-butcher'

Explanation for that is found on the [Vagrant Plugins Documentation](http://vagrantup.com/v1/docs/extending/types.html)

## Usage

The plugin is loaded automatically once installed.

By default, the gem looks for the Chef server settings on `$HOME/.chef/knife.rb`. This can be overrdidden by setting:

    Vagrant::Config.run do |config|
      config.vm.provision :chef_solo do |chef|
        chef.knife_config = '/path/to/knife.rb'
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

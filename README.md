[![Gem Version](https://badge.fury.io/rb/vagrant-butcher.png)](http://badge.fury.io/rb/vagrant-butcher)
[![Build Status](https://travis-ci.org/cassianoleal/vagrant-butcher.png)](https://travis-ci.org/cassianoleal/vagrant-butcher)

# Vagrant::Butcher

If you're using Vagrant with the Chef-Client provisioner, e.g. for creating cookbooks, it creates a client and a node on the Chef server. Once you destroy the VM, both the client and node will be kept on the server, which may cause problems if you fire up the same VM again.

This gem attempts to correct that.

## Changelog

### Version 1.0.0.pre3

* Fix call to `Config#finalize!`

### Version 1.0.0.pre2

* Should work with any provider.

### Version 1.0.0.pre

* Support for Vagrant 1.x (it's been tested on 1.4, but should work on previous minor releases) -- if you're using a pre-1.0 Vagrant release, stick to vagrant-butcher 0.0.3.
* [Configuration](#usage) change.
* [Installation](#install) via `vagrant plugin` only.

### Version 0.0.3

* Uses chef.node_name if set. Otherwise, fall back to vm.host_name (as before), or vm.box. -- _Kudos to [pikesley](https://github.com/pikesley)_.

## <a id="install"></a>Installation

Starting with version 1.0.0, installation is made via Vagrant plugins only:

    $ vagrant plugin install vagrant-butcher --plugin-source https://rubygems.org --plugin-version 1.0.0.pre3

## <a id='usage'></a>Usage

The plugin is loaded automatically once installed.

By default, the gem looks for the Chef server settings on `$HOME/.chef/knife.rb`. This can be overrdidden by setting:

    Vagrant.configure("2") do |config|
      config.butcher.knife_config_path = '/path/to/knife.rb'
      config.vm.provision :chef_client do |chef|
        # Chef Client provisioner configuration
      end
    end

_Note that beginning with 1.0, the configuration is done outside of the `chef_client` provisioner._

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

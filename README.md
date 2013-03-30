[![Gem Version](https://badge.fury.io/rb/vagrant-butcher.png)](http://badge.fury.io/rb/vagrant-butcher)
[![Build Status](https://travis-ci.org/cassianoleal/vagrant-butcher.png)](https://travis-ci.org/cassianoleal/vagrant-butcher)
[![Code Climate](https://codeclimate.com/github/cassianoleal/vagrant-butcher.png)](https://codeclimate.com/github/cassianoleal/vagrant-butcher)

# Vagrant::Butcher

If you're using Vagrant with the Chef-Client provisioner it creates a client and a node on the Chef server when the VM spins up.

This plugin will automatically get rid of that cruft for you when you destroy the VM.

## Changelog

### 1.0.0

* Support for Vagrant 1.x (it's been tested on 1.4, but should work on previous minor releases) -- if you're using a pre-1.0 Vagrant release, stick to vagrant-butcher 0.0.3.
* [Configuration](#usage) change.
* [Installation](#install) via `vagrant plugin` only.

### 0.0.3

* Uses chef.node_name if set. Otherwise, fall back to vm.host_name (as before), or vm.box. -- _Kudos to [pikesley](https://github.com/pikesley)_.

## <a id="install"></a>Installation

Starting with version 1.0.0, installation is made via Vagrant plugins only:

    $ vagrant plugin install vagrant-butcher

## <a id='usage'></a>Usage

The plugin is loaded automatically once installed.

By default, the gem looks for the Chef server settings on `$HOME/.chef/knife.rb`. This can be overridden by setting:

    Vagrant.configure("2") do |config|
      config.butcher.knife_config_file = '/path/to/knife.rb'
      config.vm.provision :chef_client do |chef|
        # Chef Client provisioner configuration
      end
    end

_Note that beginning with 1.0, the configuration is done outside of the `chef_client` provisioner._

This is the output of the plugin when it runs successfully:

    $ vagrant destroy -f
    [Butcher] knife.rb location set to '/path/to/knife.rb'
    [Butcher] Chef node 'node_name' successfully butchered from the server...
    [Butcher] Chef client 'node_name' successfully butchered from the server...
    [default] Forcing shutdown of VM...
    [default] Destroying VM and associated drives...

## Caveats

* Version 1.0 has only been tested with Vagrant 1.1+. If you're using an older version, it's probably best to stick to 0.0.3
* So far this has only been tested and confirmed to run with the VirtualBox and Rackspace provisioners. It should work with others, but if you run into issues please file a bug.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

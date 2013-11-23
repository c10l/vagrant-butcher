[![Gem Version](https://badge.fury.io/rb/vagrant-butcher.png)](http://badge.fury.io/rb/vagrant-butcher)
[![Build Status](https://travis-ci.org/cassianoleal/vagrant-butcher.png)](https://travis-ci.org/cassianoleal/vagrant-butcher)
[![Code Climate](https://codeclimate.com/github/cassianoleal/vagrant-butcher.png)](https://codeclimate.com/github/cassianoleal/vagrant-butcher)

# Vagrant::Butcher

If you're using Vagrant with the Chef-Client provisioner it creates a client and a node on the Chef server when the VM spins up.

This plugin will automatically get rid of that cruft for you when you destroy the VM.

## <a id="install"></a>Installation

Install this plugin using the Vagrant command line:

    $ vagrant plugin install vagrant-butcher --plugin-version 2.0.0.pre1 --plugin-prerelease --plugin-source https://rubygems.org

## <a id='usage'></a>Usage

The plugin is loaded automatically once installed.

Starting with version 2.0 there is no option to point to the `knife.rb` file. A temporary file is automatically generated using the information from the `Vagrantfile`. The key used to authenticate with the Chef Server is copied from the guest VM.

This way it's not necessary to have `chef` installed on the host or a properly set up `knife.rb`.

## <a id='caveats'></a>Caveats

* So far this has only been tested and confirmed to run with the VirtualBox and Rackspace provisioners. It should work with others, but if you run into issues please file a bug.
* It doesn't work with windows guests. If this is your case, either stick to version 1.x or (better) file bug reports with the errors you get.
* The default `.` -> `/vagrant` shared folder should be mounted.

## Changelog

### 2.0.0

* `chef` is no longer a requirement (no more `json` conflicts)
* `auto_knife` is now the only option

### 1.1.0

* :auto was added as an optional value for knife_config_file

### 1.0.1

* Support for Vagrant 1.2

### 1.0.0

* Support for Vagrant 1.x (it's been tested on 1.1.4, but should work on previous minor releases) -- if you're using a pre-1.0 Vagrant release, stick to vagrant-butcher 0.0.3.
* [Configuration](#usage) change.
* [Installation](#install) via `vagrant plugin` only.
* Provider-independent. _[Read more](#caveats)_

### 0.0.3

* Uses chef.node_name if set. Otherwise, fall back to vm.host_name (as before), or vm.box. -- _Kudos to [pikesley](https://github.com/pikesley)_.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

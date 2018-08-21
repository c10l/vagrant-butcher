[![Gem Version](https://badge.fury.io/rb/vagrant-butcher.png)](http://badge.fury.io/rb/vagrant-butcher)
[![Build Status](https://travis-ci.org/cassianoleal/vagrant-butcher.png)](https://travis-ci.org/cassianoleal/vagrant-butcher)
[![Code Climate](https://codeclimate.com/github/cassianoleal/vagrant-butcher.png)](https://codeclimate.com/github/cassianoleal/vagrant-butcher)

# Vagrant::Butcher

If you're using Vagrant with the Chef-Client provisioner it creates a client and a node on the Chef server when the VM spins up.

This plugin will automatically get rid of that cruft for you when you destroy the VM.

## <a id="install"></a>Installation

Install this plugin using the Vagrant command line:

    $ vagrant plugin install vagrant-butcher

## <a id='usage'></a>Usage

The plugin is loaded automatically once installed.

## <a id='configuration'></a>Configuration

For most cases, the plugin shouldn't need any configuration. However, there are a few options that can be set. The options are all set in the `Vagrantfile` in the format:

```ruby
Vagrant.configure("2") do |config|
  ...
  config.butcher.<option> = <value>
  ...
end
```

| Option           | Default Value            | Purpose                                                                |
| ---------------- | ------------------------ | ---------------------------------------------------------------------- |
| `enabled`        | `true`                   | Defines whether `node` and `client` should be deleted                  |
| `guest_key_path` | `'/etc/chef/client.pem'` | Location of the client key in the guest VM                             |
| `verify_ssl`     | `true`                   | If set to false, does not verify Chef's host key                       |
| `proxy`          | `nil`                    | Inform the URL of a proxy server between your host and the Chef Server |
| `client_name`    | Guest's node name        | Inform a client name to override the plugin's default behaviour        |
| `client_key`     | Guest's client key       | Point to a local `.pem` key file that matches the `client_name`        |

## <a id='caveats'></a>Caveats

* So far this has only been tested and confirmed to run with the VirtualBox and Rackspace provisioners. It should work with others, but if you run into issues please file a bug.
* The default `.` -> `/vagrant` shared folder should be mounted.
* `verify_ssl` is enabled by default. You might want to disable that if, for example, you run your own Chef server with a self-signed cert. Check [here](#configuration) to see how.

## Changelog

### 2.3.0

* Fix logger spam caused by Hashie used in Ridley (see [issue](https://github.com/intridea/hashie/issues/394))

### 2.2.0

* Removed compatibility with Vagrant < 1.5
* Fixes an issue with recent Vagrant versions where the butcher sequence would never run
* Sets default `guest_key_path` depending on OS
* Tested and confirmed working on Windows and Linux

### 2.0.0

* No more option to point to `knife.rb`. Data is retrieved from the `Vagrantfile`'s `chef_client` provisioner
* `chef` is no longer a requirement (no more `json` conflicts)
* [Configuration](#configuration) items were added to point to custom client name and key
* It's possible to disable the plugin by setting the `enabled` flag to `false` in the Vagrantfile.

See [Configuration](#configuration) for all possible customisations.

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

# Authors

* Cassiano Leal (<cassianoleal@gmail.com>)
* Daniel Searles ([https://github.com/squaresurf]())

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

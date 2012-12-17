# Vagrant::Butcher

If you're using Vagrant with the Chef-Client provisioner, e.g. for creating cookbooks, it creates a client and a node on the Chef server. Once you destroy the VM, both the client and node will be kept on the server, which may cause problems if you fire up the same VM again.

This gem attempts to correct that.

## Installation

Add this line to your application's Gemfile:

    gem 'vagrant-butcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vagrant-butcher

## Usage

Stick that on top of your Vagrantfile:

    require 'vagrant/butcher'
    
By default, the gem looks for `$HOME/.chef/knife.rb` for the Chef server settings. This setting can be overrdidden by setting:

    <code here>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

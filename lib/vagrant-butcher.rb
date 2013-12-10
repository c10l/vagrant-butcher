begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end
require 'vagrant-butcher/version'
require 'vagrant-butcher/errors'

module Vagrant
  module Butcher
    autoload :Action,     'vagrant-butcher/action'
    autoload :Config,     'vagrant-butcher/config'
    autoload :Env,        'vagrant-butcher/env'
    autoload :EnvHelpers, 'vagrant-butcher/env_helpers'
    autoload :Helpers,    'vagrant-butcher/helpers'
  end
end

require 'vagrant-butcher/plugin'

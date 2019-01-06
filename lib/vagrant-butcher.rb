begin
  require "vagrant"
rescue LoadError
  raise "This plugin must run within Vagrant."
end
require 'vagrant-butcher/version'
require 'vagrant-butcher/errors'

# Work around logger spam from hashie
# https://github.com/intridea/hashie/issues/394
begin
  require "hashie"
  require "hashie/logger"
  # We cannot `disable_warnings` in a subclass because
  # Hashie::Mash is used directly in the Ridley dependency:
  # https://github.com/berkshelf/ridley/search?q=Hashie&unscoped_q=Hashie
  # Therefore, we completely silence the Hashie logger as done in Berkshelf:
  # https://github.com/berkshelf/berkshelf/pull/1668/files#diff-3eca4e8b32b88ae6a1f14498e3ef7b25R5
  Hashie.logger = Logger.new(nil)
rescue LoadError
  # intentionally left blank
end

module Vagrant
  module Butcher
    autoload :Action,     'vagrant-butcher/action'
    autoload :Config,     'vagrant-butcher/config'
    autoload :Helpers,    'vagrant-butcher/helpers'
  end
end

require 'vagrant-butcher/plugin'

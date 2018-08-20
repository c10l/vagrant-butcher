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
  # Based on Hashie's recommendation to disable warnings:
  # https://github.com/intridea/hashie#how-does-mash-handle-conflicts-with-pre-existing-methods
  class Response < Hashie::Mash
    disable_warnings
  end
  # Alternatively, completely silence the logger as done in Berkshelf:
  # https://github.com/berkshelf/berkshelf/pull/1668/files
  # Hashie.logger = Logger.new(nil)
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

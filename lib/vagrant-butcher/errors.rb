require 'vagrant/errors'

module Vagrant
  module Butcher
    module Errors
      class KeyCopyFailure < ::Vagrant::Errors::VagrantError
      end

      class NoSyncedFolder < ::Vagrant::Errors::VagrantError
      end
    end
  end
end

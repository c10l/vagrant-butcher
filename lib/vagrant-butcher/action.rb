module Vagrant
  module Butcher
    module Action
      autoload :Cleanup, 'vagrant-butcher/action/cleanup'
      autoload :CopyGuestKey, 'vagrant-butcher/action/copy_guest_key'

      def self.cleanup
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use Vagrant::Butcher::Action::Cleanup
        end
      end

      def self.copy_guest_key
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use Vagrant::Butcher::Action::CopyGuestKey
        end
      end
    end
  end
end

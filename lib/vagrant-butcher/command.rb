module Vagrant
  module Butcher
    class Command < Vagrant.plugin('2', 'command')
      include ::Vagrant::Butcher::Helpers::Command
      include ::Vagrant::Butcher::Helpers::KeyFiles
      include ::Vagrant::Butcher::Helpers::Connection

      def execute
        copy_guest_key(@env)
        cleanup(@env)
      end
    end
  end
end

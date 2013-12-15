module Vagrant
  module Butcher
    class Command < Vagrant.plugin('2', 'command')
      include ::Vagrant::Butcher::Helpers::Command
      include ::Vagrant::Butcher::Helpers::KeyFiles
      include ::Vagrant::Butcher::Helpers::Connection

      def execute
        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant butcher [machine1 [machine2 [...]]]"
        end

        argv = parse_options(opts)

        with_target_vms(argv) do |machine|
          @machine = machine
          copy_guest_key(@env)
          cleanup(@env)
        end
      end
    end
  end
end

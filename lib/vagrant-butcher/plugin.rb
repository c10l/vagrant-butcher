require 'vagrant'

module Vagrant
  module Butcher
    autoload :Config, 'vagrant-butcher/config'
    
    class Plugin < Vagrant.plugin("2")
      name "vagrant-butcher"
      description <<-DESC
      When a Vagrant VM that was spun up using Chef-Client is destroyed, it leaves behind a client and a node
      on the Chef server. What butcher does is to clean up those during the destroy operation.
      DESC
      
      action_hook(:vagrant_butcher_cleanup, :machine_action_destroy) do |hook|
        hook.after(::Vagrant::Action::Builtin::GracefulHalt, Vagrant::Butcher::Action.cleanup)
      end
      
      config(:butcher) do
        Vagrant::Butcher::Config
      end
    end
  end
end

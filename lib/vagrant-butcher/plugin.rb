require 'chef/config'
require 'chef/rest'
require 'chef/api_client'

module Vagrant
  module Butcher
    class Plugin < Vagrant.plugin('2')
      name "vagrant-butcher"
      description <<-DESC
      Delete node and client from the Chef server when destroying the VM.
      DESC

      class << self
        def provision(hook)
          # This should be at the end so that it can copy the chef client pem.
          hook.append(::Vagrant::Butcher::Action.auto_knife)
        end
      end

      action_hook(:vagrant_butcher_auto_knife, :machine_action_up, &method(:provision))
      action_hook(:vagrant_butcher_auto_knife, :machine_action_reload, &method(:provision))
      action_hook(:vagrant_butcher_auto_knife, :machine_action_provision, &method(:provision))

      action_hook(:vagrant_butcher_cleanup, :machine_action_destroy) do |hook|
        hook.after(::Vagrant::Action::Builtin::ConfigValidate, Vagrant::Butcher::Action.cleanup)
      end

      config("butcher") do
        Config
      end
    end
  end
end

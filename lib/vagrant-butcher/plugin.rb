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
          hook.before(::Vagrant::Action::Builtin::Provision, Vagrant::Butcher::Action.copy_guest_key)
        end
      end

      action_hook(:vagrant_butcher_copy_guest_key, :machine_action_up, &method(:provision))
      action_hook(:vagrant_butcher_copy_guest_key, :machine_action_reload, &method(:provision))
      action_hook(:vagrant_butcher_copy_guest_key, :machine_action_provision, &method(:provision))

      action_hook(:vagrant_butcher_cleanup, :machine_action_destroy) do |hook|
        hook.before(::Vagrant::Action::Builtin::ProvisionerCleanup, Vagrant::Butcher::Action.cleanup)
      end

      config("butcher") do
        Config
      end
    end
  end
end

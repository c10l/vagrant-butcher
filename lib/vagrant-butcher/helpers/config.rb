module Vagrant
  module Butcher
    module Helpers
      module Config

        def vm_config(env)
          @vm_config ||= machine(env).config.vm
        end

        def butcher_config(env)
          @butcher_config ||= machine(env).config.butcher
        end

        def chef_provisioner(env)
          @chef_provisioner ||= vm_config(env).provisioners.find do |p|
            p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
          end.config
        end

        def chef_client?(env)
          vm_config(env).provisioners.select do |p|
            # At some point, Vagrant changed from name to type.
            p.name == :chef_client || \
            p.type == :chef_client
          end.any?
        end

        def client_name(env)
          @client_name ||= butcher_config(env).client_name || victim(env)
        end

        def victim(env)
          @victim ||= chef_provisioner(env).node_name || vm_config(env).hostname || vm_config(env).box
        end

      end
    end
  end
end

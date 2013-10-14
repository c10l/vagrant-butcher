module Vagrant
  module Butcher
    module EnvHelpers
      def vm_config(env)
        @vm_config ||= env[:machine].config.vm
      end

      def chef_api(env)
        ::Chef::REST.new(chef_provisioner(env).chef_server_url)
      end

      def chef_provisioner(env)
        @chef_provisioner ||= vm_config(env).provisioners.find do |p|
          p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
        end.config
      end

      def chef_client?(env)
        vm_config(env).provisioners.select { |p| p.name == :chef_client }.any?
      end

      def auto_knife?(env)
        butcher_config(env).knife_config_file == :auto
      end

      def butcher_config(env)
        @butcher_config ||= env[:machine].config.butcher
      end

      def cache_dir(env)
        unless @cache_dir
          env[:butcher].ui.info "cache dir is set to '#{butcher_config(env).cache_dir}'"
        end

        @cache_dir ||= butcher_config(env).cache_dir
      end

      def machine_cache_dir(env)
        unless @machine_cache_dir
          @machine_cache_dir = butcher_config(env).machine_cache_dir
          env[:butcher].ui.info "machine cache dir is set to '#{@machine_cache_dir}'"
        end

        @machine_cache_dir
      end

      def machine_key_path(env)
        unless @machine_key_path
          @machine_key_path = butcher_config(env).machine_key_path
          env[:butcher].ui.info "machine key path is set to '#{@machine_key_path}'"
        end

        @machine_key_path
      end

      def auto_knife_config_file(env)
        @auto_knife_config_file ||= "#{cache_dir(env)}/#{env[:machine].name}-knife.rb"
      end

      def knife_config_file(env)
        unless @knife_config_file
          if auto_knife?(env)
            file = "#{cache_dir(env)}/#{env[:machine].name}-knife.rb"
            unless File.exists?(file)
              file = false
            end
          else
            file = butcher_config(env).knife_config_file
          end

          env[:butcher].ui.info "knife.rb location set to '#{file}'"

          @knife_config_file = file
        end

        @knife_config_file
      end

      def auto_knife_key(env)
        unless @auto_knife_key
          @auto_knife_key = "#{env[:machine].name}-client.pem"
          env[:butcher].ui.info "auto client key name is #{@auto_knife_key}"
        end

        @auto_knife_key
      end

      def auto_knife_key_path(env)
        unless @auto_knife_key_path
          @auto_knife_key_path = "#{cache_dir(env)}/#{auto_knife_key(env)}"
          env[:butcher].ui.info "auto client key path is #{@auto_knife_key_path}"
        end

        @auto_knife_key_path
      end

      def auto_knife_machine_key_path(env)
        unless @auto_knife_machine_key_path
          @auto_knife_machine_key_path = "#{machine_cache_dir(env)}/#{auto_knife_key(env)}"
          env[:butcher].ui.info "auto client machine key path is #{@auto_knife_machine_key_path}"
        end

        @auto_knife_machine_key_path
      end

      def victim(env)
        @victim ||= chef_provisioner(env).node_name || vm_config(env).hostname || vm_config(env).box
      end
    end
  end
end

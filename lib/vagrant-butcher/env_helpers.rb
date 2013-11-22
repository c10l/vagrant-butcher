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

        @cache_dir = butcher_config(env).cache_dir
      end

      def guest_cache_dir(env)
        unless @guest_cache_dir
          @guest_cache_dir = false

          vm_config(env).synced_folders.each_value do |f|
            next if f[:disabled]

            regex = Regexp.new('^' + Regexp.quote(File.expand_path(f[:hostpath])))
            if cache_dir(env) =~ regex
              @guest_cache_dir = cache_dir(env).gsub(regex, f[:guestpath])
              break
            end
          end

          if (@guest_cache_dir)
            env[:butcher].ui.info "guest cache dir is set to '#{@guest_cache_dir}'"
          else
            env[:butcher].ui.error "We couldn't find a synced folder to access the cache dir on the guest."
            env[:butcher].ui.error "Did you disable the /vagrant folder or set a butcher.cache_path that isn't shared with the guest?"
          end
        end

        @guest_cache_dir
      end

      def guest_key_path(env)
        unless @guest_key_path
          @guest_key_path = butcher_config(env).guest_key_path
          env[:butcher].ui.info "guest key path is set to '#{@guest_key_path}'"
        end

        @guest_key_path
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

      def auto_knife_guest_key_path(env)
        unless @auto_knife_guest_key_path
          @auto_knife_guest_key_path = "#{guest_cache_dir(env)}/#{auto_knife_key(env)}"
          env[:butcher].ui.info "auto client guest key path is #{@auto_knife_guest_key_path}"
        end

        @auto_knife_guest_key_path
      end

      def victim(env)
        @victim ||= chef_provisioner(env).node_name || vm_config(env).hostname || vm_config(env).box
      end
    end
  end
end

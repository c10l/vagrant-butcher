require 'ridley'

# Silence celluloid warnings and errors: https://github.com/RiotGames/ridley/issues/220
::Ridley::Logging.logger.level = Logger.const_get 'FATAL'

module Vagrant
  module Butcher
    module EnvHelpers
      def vm_config(env)
        @vm_config ||= env[:machine].config.vm
      end

      def setup_connection(env)
        unless @conn
          begin
            @conn = ::Ridley.new(
              server_url: chef_provisioner(env).chef_server_url,
              client_name: victim(env),
              client_key: auto_knife_key_path(env),
              ssl: {
                verify: butcher_config(env).verify_ssl
              },
              retries: butcher_config(env).retries,
              retry_interval: butcher_config(env).retry_interval,
              proxy: butcher_config(env).proxy
            )
          rescue Ridley::Errors::ClientKeyFileNotFound
            env[:butcher].ui.error "Chef client key not found at #{auto_knife_key_path(env)}"
          end
        end
        @conn
      end

      def chef_provisioner(env)
        @chef_provisioner ||= vm_config(env).provisioners.find do |p|
          p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
        end.config
      end

      def chef_client?(env)
        vm_config(env).provisioners.select { |p| p.name == :chef_client }.any?
      end

      def butcher_config(env)
        @butcher_config ||= env[:machine].config.butcher
      end

      def cache_dir(env)
        @cache_dir ||= butcher_config(env).cache_dir
      end

      def cache_dir_pair(env)
        unless @cache_dir_pair
          # Grab all enabled synced_folders
          synced_folders = vm_config(env).synced_folders.values.find_all { |f| !f[:disabled] }

          # Expand the hostpath of each folder
          synced_folders.each { |f| f[:hostpath] = File.expand_path(f[:hostpath]) }

          # Select the folder wherein the cache_dir is contained
          cache_dir_pairs = synced_folders.select { |f| cache_dir(env) =~ /^#{f[:hostpath]}/ }
          @cache_dir_pair = cache_dir_pairs.first if cache_dir_pairs.any?
        end
        @cache_dir_pair
      end

      def guest_cache_dir(env)
        unless @guest_cache_dir
          if cache_dir_pair(env)
            # Return the path to the cache dir inside the VM
            @guest_cache_dir = cache_dir(env).gsub(cache_dir_pair(env)[:hostpath], cache_dir_pair(env)[:guestpath])
            env[:butcher].ui.info "Guest cache dir at #{@guest_cache_dir}"
          else
            @guest_cache_dir = false
            env[:butcher].ui.error "We couldn't find a synced folder to access the cache dir on the guest."
            env[:butcher].ui.error "Did you disable the /vagrant folder or set a butcher.cache_path that isn't shared with the guest?"
          end
        end
        @guest_cache_dir
      end

      def guest_key_path(env)
        @guest_key_path ||= butcher_config(env).guest_key_path
      end

      def auto_knife_config_file(env)
        @auto_knife_config_file ||= "#{cache_dir(env)}/#{env[:machine].name}-knife.rb"
      end

      def knife_config_file(env)
        unless @knife_config_file
          file = "#{cache_dir(env)}/#{env[:machine].name}-knife.rb"
          unless File.exists?(file)
            file = false
          end

          env[:butcher].ui.info "knife.rb location set to '#{file}'"

          @knife_config_file = file
        end

        @knife_config_file
      end

      def auto_knife_key(env)
        @auto_knife_key ||= "#{env[:machine].name}-client.pem"
      end

      def auto_knife_key_path(env)
        @auto_knife_key_path ||= "#{cache_dir(env)}/#{auto_knife_key(env)}"
      end

      def auto_knife_guest_key_path(env)
        @auto_knife_guest_key_path ||= "#{guest_cache_dir(env)}/#{auto_knife_key(env)}"
      end

      def victim(env)
        @victim ||= chef_provisioner(env).node_name || vm_config(env).hostname || vm_config(env).box
      end
    end
  end
end

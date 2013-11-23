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
        if ! @conn
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

          unless @guest_cache_dir
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

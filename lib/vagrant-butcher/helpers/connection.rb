require 'ridley'

# Silence celluloid warnings and errors: https://github.com/RiotGames/ridley/issues/220
::Ridley::Logging.logger.level = Logger.const_get 'FATAL'

module Vagrant
  module Butcher
    module Helpers
      module Connection
        include ::Vagrant::Butcher::Helpers::KeyFiles

        def setup_connection(env)
          begin
            @conn = ::Ridley.new(
              server_url: chef_provisioner(env).chef_server_url,
              client_name: client_name(env),
              client_key: client_key_path(env),
              ssl: {
                verify: butcher_config(env).verify_ssl
              },
              retries: butcher_config(env).retries,
              retry_interval: butcher_config(env).retry_interval,
              proxy: butcher_config(env).proxy
            )
          rescue Ridley::Errors::ClientKeyFileNotFoundOrInvalid
            env[:ui].error "Chef client key not found at #{client_key_path(env)}"
          rescue Exception => e
            env[:ui].error "Could not connect to Chef Server: #{e}"
          end
        end

        def delete_resource(resource, env)
          begin
            @conn.send(resource.to_sym).delete(victim(env))
            env[:ui].success "Chef #{resource} '#{victim(env)}' successfully butchered from the server..."
          rescue Exception => e
            env[:ui].warn "Could not butcher #{resource} #{victim(env)}: #{e.message}"
            @failed_deletions ||= []
            @failed_deletions << resource
          end
        end

        def cleanup(env)
          if chef_client?(env)
            setup_connection(env)
            %w(node client).each { |resource| delete_resource(resource, env) }
            cleanup_cache_dir(env)
          end
        end

      end
    end
  end
end

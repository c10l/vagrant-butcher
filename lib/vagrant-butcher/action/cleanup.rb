module Vagrant
  module Butcher
    module Action
      class Cleanup
        include ::Vagrant::Butcher::Helpers::Action
        include ::Vagrant::Butcher::Helpers::KeyFiles
        include ::Vagrant::Butcher::Helpers::Connection

        def initialize(app, env)
          @app = app
        end

        def call(env)
          setup_connection(env)

          if butcher_config(machine(env)).enabled
            if chef_client?(env)
              %w(node client).each { |resource| delete_resource(resource, env) }
              cleanup_cache_dir(env)
            end
          else
            ui(env).warn "Vagrant::Butcher disabled, not cleaning up Chef server!"
          end

          @app.call(env)
        end
      end
    end
  end
end

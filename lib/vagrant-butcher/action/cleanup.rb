module Vagrant
  module Butcher
    module Action
      class Cleanup
        include ::Vagrant::Butcher::Helpers::Action
        include ::Vagrant::Butcher::Helpers::Connection

        def initialize(app, env)
          @app = app
        end

        def call(env)
          if butcher_config(machine(env)).enabled
            grab_key_from_guest(env) unless client_key_cached?(env)
            cleanup(env)
          else
            env[:ui].warn "Vagrant::Butcher disabled, not cleaning up Chef server!"
          end
          @app.call(env)
        end
      end
    end
  end
end

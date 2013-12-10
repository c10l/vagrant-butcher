module Vagrant
  module Butcher
    module Action
      class CopyGuestKey
        include ::Vagrant::Butcher::Helpers::Action
        include ::Vagrant::Butcher::Helpers::KeyFiles

        def initialize(app, env)
          @app = app
        end

        def call(env)
          begin
            @app.call(env)
          ensure
            copy_guest_key(env) if chef_client?(env)
          end
        end

      end
    end
  end
end

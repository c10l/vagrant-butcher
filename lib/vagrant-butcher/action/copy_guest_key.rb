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
            if chef_client?(env)
              begin
                guest_cache_dir(env)
                copy_key_from_guest(env)
              rescue ::Vagrant::Errors::VagrantError => e
                ui(env).error "Failed to copy Chef client key from the guest: #{e.class}"
              end
            end
          end
        end
      end
    end
  end
end

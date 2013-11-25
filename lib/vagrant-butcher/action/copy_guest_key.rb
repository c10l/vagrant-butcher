module Vagrant
  module Butcher
    module Action
      class CopyGuestKey
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def create_cache_dir(env)
          unless File.exists?(cache_dir(env))
            env[:butcher].ui.info "Creating #{cache_dir(env)}"
            Dir.mkdir(cache_dir(env))
          end
        end

        def copy_key_from_guest(env)
          create_cache_dir(env)

          begin
            env[:machine].communicate.execute "cp #{guest_key_path(env)} #{guest_cache_key_path(env)}", :sudo => true
            env[:butcher].ui.info "Copied #{guest_key_path(env)} to #{guest_cache_key_path(env)}"
          rescue Exception => e
            env[:butcher].ui.error "Failed to copy #{guest_key_path(env)} to #{guest_cache_key_path(env)}"
            env[:butcher].ui.error e
            return false
          end

          return true
        end

        def call(env)
          if chef_client?(env)
            unless guest_cache_dir(env) && copy_key_from_guest(env)
              env[:butcher].ui.error "Failed to copy Chef client key from the guest."
            end
          end

          @app.call(env)
        end
      end
    end
  end
end

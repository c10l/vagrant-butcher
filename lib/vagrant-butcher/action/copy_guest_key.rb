module Vagrant
  module Butcher
    module Action
      class CopyGuestKey
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def copy_key_from_guest(env)
          if !guest_cache_dir(env)
            return false
          end

          unless File.exists?(cache_dir(env))
            env[:butcher].ui.info "Creating #{cache_dir(env)}"
            Dir.mkdir(cache_dir(env))
          end

          begin
            env[:machine].communicate.execute "cp #{guest_key_path(env)} #{guest_client_key_path(env)}", :sudo => true
          rescue Exception => e
            env[:butcher].ui.error "Failed to copy  #{guest_key_path(env)} to #{client_key_path(env)}"
            env[:butcher].ui.error e
            return false
          end

          env[:butcher].ui.info "Copied #{guest_key_path(env)} to #{client_key_path(env)}"

          return true
        end

        def call(env)
          if chef_client?(env)
            unless copy_key_from_guest(env)
              env[:butcher].ui.error "Failed to copy Chef client key from the guest."
            end
          end

          @app.call(env)
        end
      end
    end
  end
end

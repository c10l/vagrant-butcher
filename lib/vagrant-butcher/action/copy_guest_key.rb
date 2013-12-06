module Vagrant
  module Butcher
    module Action
      class CopyGuestKey
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def ui(env)
          @ui ||= env[:butcher].ui
        end

        def create_cache_dir(env)
          unless File.exists?(cache_dir(env))
            ui(env).info "Creating #{cache_dir(env)}"
            Dir.mkdir(cache_dir(env))
          end
        end

        def copy_key_from_guest(env)
          create_cache_dir(env)

          begin
            env[:machine].communicate.execute "cp #{guest_key_path(env)} #{guest_cache_key_path(env)}", :sudo => true
            ui(env).info "Copied #{guest_key_path(env)} to #{guest_cache_key_path(env)}"
          rescue Exception => e
            ui(env).error "Failed to copy #{guest_key_path(env)} to #{guest_cache_key_path(env)}"
            ui(env).error e
            return false
          end

          return true
        end

        def call(env)
          begin
            @app.call(env)
          ensure
            if chef_client?(env)
              unless guest_cache_dir(env) && copy_key_from_guest(env)
                ui(env).error "Failed to copy Chef client key from the guest."
              end
            end
          end
        end
      end
    end
  end
end

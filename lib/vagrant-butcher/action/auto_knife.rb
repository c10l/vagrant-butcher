module Vagrant
  module Butcher
    module Action
      class AutoKnife
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def auto_create_knife(env)
          if !guest_cache_dir(env)
            return false
          end

          unless File.exists?(cache_dir(env))
            env[:butcher].ui.info "Creating #{cache_dir(env)}"
            Dir.mkdir(cache_dir(env))
          end

          begin
            env[:machine].communicate.execute "cp #{guest_key_path(env)} #{auto_knife_guest_key_path(env)}", :sudo => true
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
            unless auto_create_knife(env)
              env[:butcher].ui.error "Failed to auto create knife.rb."
            end
          end

          @app.call(env)
        end
      end
    end
  end
end

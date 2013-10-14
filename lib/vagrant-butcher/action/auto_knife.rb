require 'chef/config'
require 'chef/rest'
require 'chef/api_client'

module Vagrant
  module Butcher
    module Action
      class AutoKnife
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def victim(env)
          @victim ||= chef_provisioner(env).node_name || vm_config(env).hostname || vm_config(env).box
        end

        def auto_create_knife(env)
          unless File.exists?(cache_dir(env))
            env[:butcher].ui.info "Creating #{cache_dir(env)}"
            Dir.mkdir(cache_dir(env))
          end

          begin
            env[:machine].communicate.execute "cp #{guest_key_path(env)} #{auto_knife_guest_key_path(env)}", :sudo => true
          rescue Exception => e
            env[:butcher].ui.error "Failed to copy  #{guest_key_path(env)} to #{auto_knife_key_path(env)}"
            env[:butcher].ui.error e
            return false
          end

          env[:butcher].ui.info "Copied #{guest_key_path(env)} to #{auto_knife_key_path(env)}"

          env[:butcher].ui.info "Creating #{auto_knife_config_file(env)}"

          knife_rb = <<-END.gsub(/^ */, '')
            log_level                :info
            log_location             STDOUT
            client_key               '#{auto_knife_key_path(env)}'
            node_name                '#{victim(env)}'
          END

          File.new(auto_knife_config_file(env), 'w+').write(knife_rb)

          return true
        end

        def call(env)
          if chef_client?(env) && auto_knife?(env) && !File.exists?(auto_knife_config_file(env))
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

module Vagrant
  module Butcher
    module Action
      class Cleanup
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
          @delete_all_success = true
        end

        def delete_resource(resource, env)
          begin
            chef_api(env).delete_rest("#{resource}s/#{victim(env)}")
            env[:butcher].ui.success "Chef #{resource} '#{victim(env)}' successfully butchered from the server..."
          rescue Exception => e
            env[:butcher].ui.warn "Could not remove #{resource} #{victim(env)}: #{e.message}"
            @delete_all_success = false
          end
        end

        def delete_auto_knife(env)
          if @delete_all_success
            File.delete(auto_knife_config_file(env))
            File.delete(auto_knife_key_path(env))
            begin
              Dir.delete(cache_dir(env))
            rescue
              # The dir wasn't empty.
            end
          end
        end

        def call(env)
          if chef_client?(env) && knife_config_file(env)
            begin
              ::Chef::Config.from_file knife_config_file(env)
            rescue Errno::ENOENT => e
              raise ::Vagrant::Butcher::VagrantWrapperError.new(e)
            end

            %w(node client).each { |resource| delete_resource(resource, env) }

            if auto_knife?(env)
              delete_auto_knife(env)
            end
          end

          @app.call(env)
        end
      end
    end
  end
end

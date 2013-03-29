require 'chef/config'
require 'chef/rest'
require 'chef/api_client'

module Vagrant
  module Butcher
    module Action
      class Cleanup
        include ::Vagrant::Butcher::EnvHelpers

        def initialize(app, env)
          @app = app
          @env = env
        end

        def victim
          @victim ||= chef_provisioner(@env).node_name || vm_config(@env).hostname || vm_config(@env).box
        end

        def delete_resource(resource)
          begin
            chef_api(@env).delete_rest("#{resource}s/#{victim}")
            @env[:butcher].ui.success "Chef #{resource} \"#{victim}\" successfully butchered from the server..."
          rescue Exception => e
            @env[:butcher].ui.warn "Could not remove #{resource} #{victim}: #{e.message}"
          end
        end

        def call(env)
          if chef_client?(env)
            begin
              ::Chef::Config.from_file knife_config_file(env)
            rescue Errno::ENOENT => e
              raise ::Vagrant::Butcher::VagrantWrapperError.new(e)
            end

            %w(node client).each { |resource| delete_resource(resource) }
          end

          @app.call(env)
        end
      end
    end
  end
end

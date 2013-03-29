require 'chef/config'
require 'chef/rest'
require 'chef/api_client'

module Vagrant
  module Butcher
    module Action
      class Cleanup
        def initialize(app, env)
          @app = app
          @env = env
        end

        def vm_config; @vm_config ||= @env[:machine].config.vm;                                          end
        def chef_api ; @chef_api  ||= ::Chef::REST.new(chef_provisioner.chef_server_url);                end
        def victim   ; @victim    ||= chef_provisioner.node_name || vm_config.hostname || vm_config.box; end

        def chef_provisioner
          @chef_provisioner ||= vm_config.provisioners.find do |p|
            p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
          end.config
        end

        def chef_client?
          vm_config.provisioners.select { |p| p.name == :chef_client }.any?
        end

        def delete_resource(resource)
          begin
            chef_api.delete_rest("#{resource}s/#{victim}")
            @env[:butcher].ui.success "Chef #{resource} \"#{victim}\" successfully butchered from the server..."
          rescue Exception => e
            @env[:butcher].ui.warn "Could not remove #{resource} #{victim}: #{e.message}"
          end
        end

        def knife_config_file(env)
          # Make sure that the default is set
          env[:machine].config.butcher.finalize!

          env[:butcher].ui.info "knife.rb location set to '#{env[:machine].config.butcher.knife_config_file}'"
          env[:machine].config.butcher.knife_config_file
        end

        def call(env)
          if chef_client?
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

module Vagrant
  module Provisioners
    class ChefClient < Chef
      def cleanup_chef_server(host_name)
        env[:ui].info "Removing node and client \"#{host_name}\" from Chef server"
        [::Chef::Node, ::Chef::ApiClient].each do |chef_resource|
          begin
            chef_resource = chef_resource.load(host_name)
            chef_resource.destroy
          rescue Exception => e
            env[:ui].warn "Could not destroy #{chef_resource} #{host_name}: #{e.message}"
          end
        end
      end

      def cleanup
        ::Chef::Config.from_file(config.knife_config)
        cleanup_chef_server(env[:vm].config.vm.host_name)
      end
    end
  end
end

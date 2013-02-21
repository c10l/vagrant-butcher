module Vagrant
  module Provisioners
    class ChefClient < Chef
      class Config < Chef::Config
        attr_accessor :knife_config
        def knife_config; @knife_config || "#{ENV['HOME']}/.chef/knife.rb"; end
      end

      def cleanup_chef_server(node_name)
        chef_api = ::Chef::REST.new(::Chef::Config[:chef_server_url])
        %w(node client).each do |resource|
          env[:ui].info "Removing Chef #{resource} \"#{node_name}\"..."
          begin
            chef_api.delete_rest("#{resource}s/#{node_name}")
          rescue Exception => e
            env[:ui].warn "Could not remove #{resource} #{node_name}: #{e.message}"
          end
        end
      end

      def cleanup
        ::Chef::Config.from_file(config.knife_config)
        conf = env[:vm].config.vm

        # If a node_name is given to the chef-client provisioner, use it
        chef_provisioner = conf.provisioners.find { |p| p.provisioner.name == "Vagrant::Provisioners::ChefClient" }
        victim = chef_provisioner.config.node_name

        # If no node_name, fall back to host_name or box
        if not victim then
          env[:ui].info "No chef.node_name set, falling back to vm.host_name or vm.box."
          victim ||= conf.host_name || conf.box
        end

        cleanup_chef_server(victim)
      end
    end
  end
end

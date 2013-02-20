module Vagrant
  module Provisioners
    class ChefClient < Chef
      class Config < Chef::Config
        attr_accessor :knife_config
        def knife_config; @knife_config || "#{ENV['HOME']}/.chef/knife.rb"; end
      end

      def cleanup_chef_server(host_name)
        chef_api = ::Chef::REST.new(::Chef::Config[:chef_server_url])
        %w(node client).each do |resource|
          env[:ui].info "Removing Chef #{resource} \"#{host_name}\"..."
          begin
            chef_api.delete_rest("#{resource}s/#{host_name}")
          rescue Exception => e
            env[:ui].warn "Could not remove #{resource} #{host_name}: #{e.message}"
          end
        end
      end

      def cleanup
        ::Chef::Config.from_file(config.knife_config)
        conf = env[:vm].config.vm

        # Chef uses this name if no other names are defined
        victim = conf.box

        # if this is set then the Chef will use it
        victim = conf.host_name if conf.host_name

        provs = conf.provisioners
        provs.each do |p|
          if p.provisioner.name == "Vagrant::Provisioners::ChefClient"

            # or if this one is set, Chef will use this
            victim = p.config.node_name if p.config.node_name
          end
        end
        cleanup_chef_server(victim)
      end
    end
  end
end

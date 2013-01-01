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
        cleanup_chef_server(env[:vm].config.vm.host_name)
      end
    end
  end
end

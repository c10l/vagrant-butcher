module Vagrant
  module Provisioners
    class ChefClient < Chef
      class Config < Chef::Config
        attr_accessor :knife_config
        def knife_config; @knife_config || "#{ENV['HOME']}/.chef/knife.rb"; end
      end

      attr_writer :vm_config, :chef_api, :victim, :chef_provisioner
      def vm_config; @vm_config ||= env[:vm].config.vm;                                                 end
      def chef_api ; @chef_api  ||= ::Chef::REST.new(chef_provisioner.chef_server_url);                 end
      def victim   ; @victim    ||= chef_provisioner.node_name || vm_config.host_name || vm_config.box; end

      def chef_provisioner
        @chef_provisioner ||= vm_config.provisioners.find do |p|
          p.provisioner == Vagrant::Provisioners::ChefClient
        end.config
      end

      def delete_resource(resource)
        env[:ui].info "Removing Chef #{resource} \"#{victim}\"..."
        begin
          chef_api.delete_rest("#{resource}s/#{victim}")
        rescue Exception => e
          env[:ui].warn "Could not remove #{resource} #{victim}: #{e.message}"
        end
      end

      def cleanup
        ::Chef::Config.from_file(chef_provisioner.knife_config)
        %w(node client).each { |resource| delete_resource(resource) }
      end
    end
  end
end

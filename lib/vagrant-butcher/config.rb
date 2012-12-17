module Vagrant
  module Provisioners
    class ChefClient < Chef
      class Config < Chef::Config
        attr_accessor :knife_config
        def knife_config; @knife_config || "#{ENV['HOME']}/.chef/knife.rb"; end
      end
    end
  end
end

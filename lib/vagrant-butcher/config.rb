module Vagrant
  module Butcher
    class Config < ::Vagrant.plugin("2", :config)
      class << self
        attr_reader :knife_config
        
        def knife_config; @knife_config || "#{ENV['HOME']}/.chef/knife.rb"; end
      end
    end
  end
end

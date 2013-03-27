module Vagrant
  module Butcher
    class Config < ::Vagrant.plugin('2', :config)
      attr_accessor :knife_config_path
      
      def initialize
        super
        @knife_config_path = UNSET_VALUE
      end
      
      def knife_config_path=(value)
        @knife_config_path = File.expand_path(value)
      end
      
      def validate(machine)
      end
      
      def finalize!
        @knife_config_path = File.expand_path "#{ENV['HOME']}/.chef/knife.rb" if @knife_config_path == UNSET_VALUE
      end
    end
  end
end

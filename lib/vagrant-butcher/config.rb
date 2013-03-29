module Vagrant
  module Butcher
    class Config < ::Vagrant.plugin('2', :config)
      attr_accessor :knife_config_file
      
      def initialize
        super
        @knife_config_file = UNSET_VALUE
      end
      
      def knife_config_file=(value)
        @knife_config_file = File.expand_path(value)
      end
      
      def validate(machine)
        errors = []
        errors << "Knife configuration not found at #{@knife_config_file}." if !File.exists?(@knife_config_file)
        
        { "butcher configuration" => errors }
      end
      
      def finalize!
        @knife_config_file = File.expand_path "#{ENV['HOME']}/.chef/knife.rb" if @knife_config_file == UNSET_VALUE
      end
    end
  end
end

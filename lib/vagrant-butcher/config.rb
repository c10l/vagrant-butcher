module Vagrant
  module Butcher
    class Config < ::Vagrant.plugin('2', :config)
      attr_accessor :guest_key_path
      attr_accessor :cache_dir
      attr_accessor :guest_cache_dir
      attr_accessor :knife_config_file
      
      def initialize
        super
        @guest_key_path = UNSET_VALUE
        @cache_dir = UNSET_VALUE
        @guest_cache_dir = UNSET_VALUE
        @knife_config_file = UNSET_VALUE
      end

      def cache_dir=(value)
        @cache_dir = File.expand_path(value)
      end

      def knife_config_file=(value)
        unless value == :auto
          value = File.expand_path(value)
        end

        @knife_config_file = value
      end
      
      def validate(machine)
        errors = []

        if @knife_config_file != :auto && !File.exists?(@knife_config_file)
          errors << "Knife configuration not found at #{@knife_config_file}."
        end
        
        { "butcher configuration" => errors }
      end
      
      def finalize!
        @guest_key_path = '/etc/chef/client.pem' if @guest_key_path == UNSET_VALUE
        @cache_dir = File.expand_path ".vagrant-butcher" if @cache_dir == UNSET_VALUE
        @guest_cache_dir = "/vagrant/" + File.basename(@cache_dir) if @guest_cache_dir == UNSET_VALUE
        @knife_config_file = File.expand_path "#{ENV['HOME']}/.chef/knife.rb" if @knife_config_file == UNSET_VALUE
      end
    end
  end
end

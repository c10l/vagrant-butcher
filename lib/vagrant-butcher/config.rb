module Vagrant
  module Butcher
    class Config < ::Vagrant.plugin('2', :config)
      attr_accessor :guest_key_path
      attr_accessor :cache_dir
      attr_accessor :knife_config_file
      attr_accessor :verify_ssl
      attr_accessor :retries
      attr_accessor :retry_interval
      attr_accessor :proxy

      def initialize
        super
        @guest_key_path = UNSET_VALUE
        @cache_dir = UNSET_VALUE
        @knife_config_file = UNSET_VALUE
        @verify_ssl = UNSET_VALUE
        @retries = UNSET_VALUE
        @retry_interval = UNSET_VALUE
        @proxy = UNSET_VALUE
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
        @cache_dir = File.expand_path ".vagrant/butcher" if @cache_dir == UNSET_VALUE
        @knife_config_file = :auto if @knife_config_file == UNSET_VALUE
        @verify_ssl = true if @verify_ssl == UNSET_VALUE
        @retries = 0 if @retries == UNSET_VALUE
        @retry_interval = 0 if @retry_interval == UNSET_VALUE
        @proxy = nil if @proxy == UNSET_VALUE
      end
    end
  end
end

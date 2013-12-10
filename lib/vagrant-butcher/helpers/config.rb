module Vagrant
  module Butcher
    module Helpers
      module Config

        def vm_config(env)
          @vm_config ||= machine(env).config.vm
        end

        def butcher_config(env)
          @butcher_config ||= machine(env).config.butcher
        end

        def chef_provisioner(env)
          @chef_provisioner ||= vm_config(env).provisioners.find do |p|
            p.config.is_a? VagrantPlugins::Chef::Config::ChefClient
          end.config
        end

        def chef_client?(env)
          vm_config(env).provisioners.select { |p| p.name == :chef_client }.any?
        end

        def cache_dir(env)
          @cache_dir ||= butcher_config(env).cache_dir
        end

        def cache_dir_mapping(env)
          unless @cache_dir_mapping
            # Grab all enabled synced_folders
            synced_folders = vm_config(env).synced_folders.values.find_all { |f| !f[:disabled] }

            # Expand the hostpath of each folder
            synced_folders.each { |f| f[:hostpath] = File.expand_path(f[:hostpath]) }

            # Select the folder wherein the cache_dir is contained
            cache_dir_mappings = synced_folders.select { |f| cache_dir(env) =~ /^#{f[:hostpath]}/ }
            @cache_dir_mapping = cache_dir_mappings.first if cache_dir_mappings.any?
          end
          @cache_dir_mapping
        end

      end
    end
  end
end

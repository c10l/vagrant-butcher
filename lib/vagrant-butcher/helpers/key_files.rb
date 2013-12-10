module Vagrant
  module Butcher
    module Helpers
      module KeyFiles

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

        def guest_cache_dir(env)
          unless @guest_cache_dir
            if cache_dir_mapping(env)
              # Return the path to the cache dir inside the VM
              @guest_cache_dir = cache_dir(env).gsub(cache_dir_mapping(env)[:hostpath], cache_dir_mapping(env)[:guestpath])
              ui(env).info "Guest cache dir at #{@guest_cache_dir}"
            else
              ui(env).error "We couldn't find a synced folder to access the cache dir on the guest."
              ui(env).error "Did you disable the /vagrant folder or set a butcher.cache_path that isn't shared with the guest?"
              raise ::Vagrant::Butcher::Errors::NoSyncedFolder
            end
          end
          @guest_cache_dir
        end

        def guest_key_path(env)
          @guest_key_path ||= butcher_config(env).guest_key_path
        end

        def guest_key_filename(env)
          @guest_key ||= "#{env[:machine].name}-client.pem"
        end

        def guest_cache_key_path(env)
          @guest_cache_key_path ||= "#{guest_cache_dir(env)}/#{guest_key_filename(env)}"
        end

        def client_key(env)
          @client_key ||= butcher_config(env).client_key || "#{cache_dir(env)}/#{guest_key_filename(env)}"
        end

        def create_cache_dir(env)
          unless File.exists?(cache_dir(env))
            ui(env).info "Creating #{cache_dir(env)}"
            Dir.mkdir(cache_dir(env))
          end
        end

        def copy_key_file(env)
          create_cache_dir(env)

          begin
            machine(env).communicate.execute "cp #{guest_key_path(env)} #{guest_cache_key_path(env)}", :sudo => true
            ui(env).info "Copied #{guest_key_path(env)} to #{guest_cache_key_path(env)}"
          rescue Exception => e
            ui(env).error "Failed to copy #{guest_key_path(env)} to #{guest_cache_key_path(env)}"
            ui(env).error e
            raise ::Vagrant::Butcher::Errors::KeyCopyFailure
          end
        end

        def cleanup_cache_dir(env)
          unless @failed_deletions
            File.delete(client_key(env))
            begin
              Dir.delete(cache_dir(env))
            rescue Errno::ENOTEMPTY
              # The dir wasn't empty.
            end
          else
            ui(env).warn "#{@failed_deletions} not butchered from the Chef Server. Client key was left at #{client_key(env)}"
          end
        end

        def copy_guest_key(env)
          begin
            guest_cache_dir(env)
            copy_key_file(env)
          rescue ::Vagrant::Errors::VagrantError => e
            ui(env).error "Failed to copy Chef client key from the guest: #{e.class}"
          end
        end

      end
    end
  end
end

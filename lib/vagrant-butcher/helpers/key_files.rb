module Vagrant
  module Butcher
    module Helpers
      module KeyFiles

        def guest_cache_dir(env)
          unless @guest_cache_dir
            if cache_dir_mapping(env)
              # Return the path to the cache dir inside the VM
              @guest_cache_dir = cache_dir(env).gsub(cache_dir_mapping(env)[:hostpath], cache_dir_mapping(env)[:guestpath])
              ui(env).info "Guest cache dir at #{@guest_cache_dir}"
            else
              @guest_cache_dir = false
              ui(env).error "We couldn't find a synced folder to access the cache dir on the guest."
              ui(env).error "Did you disable the /vagrant folder or set a butcher.cache_path that isn't shared with the guest?"
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

      end
    end
  end
end

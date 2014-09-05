module Vagrant
  module Butcher
    module Helpers
      module Guest

        def windows?(env)
          machine(env).guest.capability_host_chain.last.first == :windows
        end

        def get_guest_key_path(env)
          return butcher_config(env).guest_key_path unless butcher_config(env).guest_key_path == :DEFAULT
          return 'c:\etc\chef\client.pem' if windows?(env)
          return '/etc/chef/client.pem'
        end

      end
    end
  end
end

module Vagrant
  module Butcher
    module Cap
      module DefaultGuestKeyPath
        module Linux
          def self.default_guest_key_path(machine)
            '/etc/chef/client.pem'
          end
        end
      end
    end
  end
end

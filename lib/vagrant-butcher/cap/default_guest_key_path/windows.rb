module Vagrant
  module Butcher
    module Cap
      module DefaultGuestKeyPath
        module Windows
          def self.default_guest_key_path(machine)
            'c:\chef\client.pem'
          end
        end
      end
    end
  end
end

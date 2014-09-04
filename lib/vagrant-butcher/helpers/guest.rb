module Vagrant
  module Butcher
    module Helpers
      module Guest

        def windows?(env)
          machine(env).guest.capability_host_chain.last.first == :windows
        end

      end
    end
  end
end

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

      end
    end
  end
end

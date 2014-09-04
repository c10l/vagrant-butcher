module Vagrant
  module Butcher
    module Helpers
      module Action
        include Config

        def machine(env)
          @machine ||= env[:machine]
        end

        def root_path(env)
          @root_path ||= env[:root_path]
        end

      end
    end
  end
end

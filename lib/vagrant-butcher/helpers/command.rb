module Vagrant
  module Butcher
    module Helpers
      module Command
        include Config

        def ui(env)
          @ui ||= env.ui
        end

        # This method is provided for compatibility with the Action API.
        # @machine should have already been set in Command#execute through
        # the use of with_target_vms
        def machine(env)
          @machine
        end

        def root_path(env)
          @root_path ||= env.root_path
        end

      end
    end
  end
end

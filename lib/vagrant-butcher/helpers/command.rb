module Vagrant
  module Butcher
    module Helpers
      module Command
        include Config

        def ui(env)
          @ui ||= env.ui
        end

        def machine(env)
          @machine ||= env.machine(:default, :virtualbox)
        end

        def root_path(env)
          @root_path ||= env.root_path
        end

      end
    end
  end
end

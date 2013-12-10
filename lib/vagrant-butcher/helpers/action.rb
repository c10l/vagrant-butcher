module Vagrant
  module Butcher
    module Helpers
      module Action
        include Config

        def ui(env)
          @ui ||= env[:butcher].ui
        end

        def machine(env)
          @machine ||= env[:machine]
        end

      end
    end
  end
end

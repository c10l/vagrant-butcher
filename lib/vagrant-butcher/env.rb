module Vagrant
  module Butcher
    class Env
      attr_accessor :ui
      
      def initialize
        @ui = ::Vagrant::UI::Colored.new('Butcher')
      end
    end
  end
end

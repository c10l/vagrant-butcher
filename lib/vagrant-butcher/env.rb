module Vagrant
  module Butcher
    class Env
      attr_accessor :ui
      
      def initialize
        if Gem::Version.new(::Vagrant::VERSION) >= Gem::Version.new("1.2")
          @ui = ::Vagrant::UI::Colored.new.scope('Butcher')
        else
          @ui = ::Vagrant::UI::Colored.new('Butcher')
        end
      end
    end
  end
end

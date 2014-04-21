module Vagrant
  module Butcher
    class Env
      attr_accessor :ui

      def initialize
        if Gem::Version.new(::Vagrant::VERSION) >= Gem::Version.new("1.2")
          if Gem::Version.new(::Vagrant::VERSION) >= Gem::Version.new("1.5")
             @ui = ::Vagrant::UI::Colored.new
          else
             @ui = ::Vagrant::UI::Colored.new.scope('Butcher')
          end
        else
          @ui = ::Vagrant::UI::Colored.new('Butcher')
        end
      end
    end
  end
end

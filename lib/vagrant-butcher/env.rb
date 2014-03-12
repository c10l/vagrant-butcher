module Vagrant
  module Butcher
    class Env
      attr_accessor :ui

      def initialize
        vagrant_version = Gem::Version.new(::Vagrant::VERSION)
        if vagrant_version >= Gem::Version.new("1.5")
          @ui = ::Vagrant::UI::Colored.new
          @ui.opts[:target] = 'Butcher'
        elsif vagrant_version >= Gem::Version.new("1.2")
          @ui = ::Vagrant::UI::Colored.new.scope('Butcher')
        else
          @ui = ::Vagrant::UI::Colored.new('Butcher')
        end
      end
    end
  end
end

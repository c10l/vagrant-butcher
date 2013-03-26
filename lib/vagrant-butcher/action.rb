module Vagrant
  module Butcher
    module Action
      autoload :Cleanup, 'vagrant-butcher/action/cleanup'
      
      def self.cleanup
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use Vagrant::Butcher::Action::Cleanup
        end
      end
    end
  end
end

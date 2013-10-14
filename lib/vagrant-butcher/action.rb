module Vagrant
  module Butcher
    module Action
      autoload :Cleanup, 'vagrant-butcher/action/cleanup'
      autoload :AutoKnife, 'vagrant-butcher/action/auto_knife'
      
      def self.cleanup
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use setup
          b.use Vagrant::Butcher::Action::Cleanup
        end
      end

      def self.auto_knife
        ::Vagrant::Action::Builder.new.tap do |b|
          b.use setup
          b.use Vagrant::Butcher::Action::AutoKnife
        end
      end

      def self.setup
        @setup ||= ::Vagrant::Action::Builder.new.tap do |b|
          b.use ::Vagrant::Action::Builtin::EnvSet, butcher: Vagrant::Butcher::Env.new
        end
      end
    end
  end
end

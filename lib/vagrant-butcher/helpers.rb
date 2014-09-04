module Vagrant
  module Butcher
    module Helpers
      autoload :Config,     'vagrant-butcher/helpers/config'
      autoload :Action,     'vagrant-butcher/helpers/action'
      autoload :KeyFiles,   'vagrant-butcher/helpers/key_files'
      autoload :Connection, 'vagrant-butcher/helpers/connection'
      autoload :Guest,      'vagrant-butcher/helpers/guest'
    end
  end
end

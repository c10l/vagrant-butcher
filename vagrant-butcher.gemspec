# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-butcher/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-butcher"
  gem.version       = Vagrant::Butcher::VERSION
  gem.authors       = ["Cassiano Leal"]
  gem.email         = ["cassianoleal@gmail.com"]
  gem.description   = %q{Delete Chef client and node when destroying Vagrant VM}
  gem.summary       = %q{When a Vagrant VM that was spun up using Chef-Client is destroyed, it leaves behind a client and a node on the Chef server. What butcher does is to clean up those during the destroy operation.}
  gem.homepage      = "https://github.com/cassianoleal/vagrant-butcher"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "ridley", "~> 5.1"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry-byebug"
  gem.add_development_dependency "did_you_mean", "= 1.2.0"
  gem.add_development_dependency "fileutils"
  gem.add_development_dependency "date"
end

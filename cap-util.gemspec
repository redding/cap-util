# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cap-util/version"

Gem::Specification.new do |gem|
  gem.name        = "cap-util"
  gem.version     = CapUtil::VERSION
  gem.authors     = ["Kelly Redding", "Collin Redding"]
  gem.email       = ["kelly@kellyredding.com", "collin.redding@me.com"]
  gem.summary     = %q{A set of utilities for writing cap tasks.}
  gem.description = %q{A set of utilities for writing cap tasks.}
  gem.homepage    = "http://github.com/redding/cap-util"
  gem.license     = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("assert", ["~> 2.16.1"])

  gem.add_dependency("scmd",       ["~> 3.0.2"])
  gem.add_dependency("capistrano", ["~> 2.0"])

end

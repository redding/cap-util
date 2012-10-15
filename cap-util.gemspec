# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cap-util/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "cap-util"
  gem.version     = CapUtil::VERSION
  gem.description = %q{A set of utilities for writing cap tasks.}
  gem.summary     = %q{A set of utilities for writing cap tasks.}

  gem.authors     = ["Kelly Redding"]
  gem.email       = ["kelly@kellyredding.com"]
  gem.homepage    = "http://github.com/redding/cap-util"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency("assert")
end

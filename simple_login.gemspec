# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_login/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Zernel"]
  gem.email         = ["itzernel@gmail.com"]
  gem.description   = %q{A simple login generator}
  gem.summary       = %q{A simple login generator}
  gem.homepage      = "https://github.com/zernel/simple_login"

  gem.add_development_dependency 'rails', '~> 3.2.0'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple_login"
  gem.require_paths = ["lib"]
  gem.version       = SimpleLogin::VERSION
end

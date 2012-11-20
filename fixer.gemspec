# -*- encoding: utf-8 -*-
require File.expand_path '../lib/fixer/version', __FILE__

Gem::Specification.new do |gem|
  gem.authors       = ['Hakan Ensari']
  gem.email         = ['hakan.ensari@papercavalier.com']
  gem.description   = 'Current and historical foreign exchange rate feeds'
  gem.summary       = 'Foreign exchange rate feeds'
  gem.homepage      = 'http://github.com/hakanensari/fixer'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename f }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'fixer'
  gem.require_paths = ['lib']
  gem.version       = Fixer::VERSION

  gem.add_runtime_dependency     'nokogiri', '~> 1.5'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end

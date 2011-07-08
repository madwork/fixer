# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fixer/version"

Gem::Specification.new do |s|
  s.name        = "fixer"
  s.version     = Fixer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paper Cavalier"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://fixer.heroku.com"
  s.summary     = "A Ruby wrapper to the European Central Bank exchange rate feeds"
  s.description = "Fixer is a Ruby wrapper to the current and historical foreign exchange or FX rate feeds of the European Central Bank."

  s.rubyforge_project = "fixer"

  s.add_dependency("nokogiri", ["~> 1.4.0"])
  s.add_development_dependency("rspec", ["~> 2.1.0"])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

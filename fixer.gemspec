# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/fixer/version"

Gem::Specification.new do |s|
  s.name        = "fixer"
  s.version     = Fixer::VERSION
  s.authors     = ["Hakan Ensari"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://fixer.heroku.com"
  s.summary     = "A Ruby wrapper to the European Central Bank exchange rate feeds"
  s.description = "Fixer is a Ruby wrapper to the current and historical foreign exchange or FX rate feeds provided by the European Central Bank."

  s.required_rubygems_version = ">= 1.3.7"

  s.add_dependency("nokogiri", ["~> 1.4.0"])

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", ["= 2.0.0.rc"])

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.markdown)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
end

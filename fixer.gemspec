# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fixer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fixer"
  s.version     = Fixer::VERSION
  s.authors     = ["Hakan Ensari"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://github.com/hakanensari/fixer"
  s.summary     = "A Ruby wrapper to the European Central Bank exchange rate feeds"
  s.description = "Fixer is a Ruby wrapper to the current and historical foreign exchange or FX rate feeds of the European Central Bank."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency("nokogiri", ["~> 1.4"])
end

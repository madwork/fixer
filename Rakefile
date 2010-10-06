require "bundler/setup"

require "rspec/core/rake_task"
require File.dirname(__FILE__) + "/lib/fixer/version"

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

namespace :gem do
  desc "Build gem"
  task :build do
    system "gem build fixer.gemspec"
  end

  desc "Release gem"
  task :release => :build do
    puts "Tagging #{Fixer::VERSION}..."
    system "git tag -a v#{Fixer::VERSION} -m 'Tagging v#{Fixer::VERSION}'"
    puts "Pushing to Github..."
    system "git push --tags"
    system "gem push sucker-#{Fixer::VERSION}.gem"
  end
end

task :default => :spec

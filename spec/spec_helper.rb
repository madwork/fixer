require "bundler/setup"
require "rspec"

require File.expand_path("../../lib/fixer", __FILE__)

RSpec::Matchers.define :be_a_snapshot do
  match do |actual|
    actual.keys.include?(:date) && actual.keys.include?(:rates)
  end
end

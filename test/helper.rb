require 'bundler/setup'
require 'test/unit'
begin
  require 'pry'
rescue LoadError
end
require 'webmock'
require 'vcr'
require File.expand_path('../../lib/fixer', __FILE__)

VCR.config do |c|
  c.cassette_library_dir = File.expand_path('../vcr_cassettes', __FILE__)
  c.stub_with :webmock
end

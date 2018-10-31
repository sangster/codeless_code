require 'simplecov'

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end

SimpleCov.configure do
  clean_filters
  load_adapter 'test_frameworks'
end

ENV['COVERAGE'] && SimpleCov.start do
  add_filter '/.rvm/'
end
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'minitest/reporters'
require 'minitest/test'
require 'minitest/autorun'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

$LOAD_PATH.unshift(__dir__)
$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
require 'pry-byebug'
require 'codeless_code'

class UnitTest < MiniTest::Test
  include CodelessCode
end

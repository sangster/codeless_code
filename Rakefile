# encoding: utf-8
$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'jeweler'
require 'pry-byebug'
require 'rake'
require 'rake/testtask'
require 'reek/rake/task'
require 'yard'

require 'codeless_code'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see
  # http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "codeless_code"
  gem.homepage = "https://github.com/sangster/codeless_code"
  gem.license = "MIT"
  gem.summary = 'Search and print The Codeless Code fables'
  gem.description = 'Search and print The Codeless Code fables'
  gem.email = "jon@ertt.ca"
  gem.authors = ["Jon Sangster"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

YARD::Rake::YardocTask.new

task default: :test

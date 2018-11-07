# frozen_string_literal: true

# codeless_code filters and prints fables from http://thecodelesscode.com
# Copyright (C) 2018  Jon Sangster
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'jeweler'
require 'pathname'
require 'pry-byebug'
require 'rake'
require 'rake/testtask'
require 'reek/rake/task'
require 'yard'

require 'codeless_code'

Jeweler::Tasks.new do |gem|
  gem.name = 'codeless_code'
  gem.homepage = 'https://github.com/sangster/codeless_code'
  gem.license = 'GPL-3.0'
  gem.summary = 'Search and print The Codeless Code fables'
  gem.description = <<-DESC.gsub(/\s+/m, ' ').strip
    http://thecodelesscode.com contains many humorous and interesting fables
    and koans. The authors have open-sourced these fables, and many
    tanslations, available at https://github.com/aldesantis/the-codeless-code.

    This tool provides a CLI to filter through these fables and view them.
  DESC
  gem.email = 'jon@ertt.ca'
  gem.authors = ['Jon Sangster']
  gem.files.include('data/**/*.txt')
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
Rake::Task[:build].prerequisites << :test

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

YARD::Rake::YardocTask.new

Rake::Task['console'].clear
desc 'Start Pry with all runtime dependencies loaded'
task :console do
  include CodelessCode
  pry
end

namespace :readme do
  readme = Pathname.new(__dir__).join('README.md')

  desc 'Update README with the app\'s options'
  task :options do
    help = CodelessCode::Options.new('codeless_code', []).help.gsub(/ +$/, '')
    readme.write(
      readme.read.gsub(/(^\s*#+ Current Options).+?(^\s*#)/m,
                       format("\\1\n\n```\n%s```\n\\2", help))
    )
  end
end

namespace :lint do
  require 'reek/rake/task'
  require 'rubocop/rake_task'

  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
  end

  RuboCop::RakeTask.new
end

desc 'Run all linters'
task lint: ['lint:rubocop', 'lint:reek']

task default: %i[test lint]

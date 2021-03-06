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
require 'simplecov'

module SimpleCov
  module Configuration
    def clean_filters
      @filters = []
    end
  end
end

SimpleCov.configure do
  clean_filters
  load_profile 'test_frameworks'
end

ENV['COVERAGE'] && SimpleCov.start do
  add_filter %r{/\..*/}
  add_filter %r{/vendor/.*}
end

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'minitest/reporters'
require 'minitest/test'
require 'minitest/autorun'

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

$LOAD_PATH.unshift(File.join(__dir__))
$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
require 'pry-byebug'
require 'codeless_code'
require 'support/fs'

# Don't allow real data for tests
CodelessCode.send(:remove_const, :DEFAULT_DATA)

class UnitTest < MiniTest::Test
  include CodelessCode
  include Support

  def mock_fable(content, dir: 'en-test')
    Fable.new(
      StringIO.new(content.strip).tap do |io|
        io.define_singleton_method(:open) { self }
        io.define_singleton_method(:close) { self }
        io.define_singleton_method(:parent) do
          Pathname.new('/test').join(dir)
        end
        io.rewind
      end
    )
  end

  def catalog(dir = fake_fs)
    (@catalog ||= {})[dir] ||= Catalog.new(dir)
  end

  def options(*args)
    (@options ||= {})[args] ||= Options.new('codeless_code', args)
  end
end

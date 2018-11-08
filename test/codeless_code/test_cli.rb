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
require 'helper'
require 'minitest/mock'

class TestCli < UnitTest
  def setup
    @pager = ENV.delete('PAGER')
  end

  def teardown
    ENV['PAGER'] = @pager
  end

  def test_call_default
    expected = "00123  Test Case\n00234  Test Case 2\n"
    assert_output(expected) { cli.call }
  end

  def test_call_single_by_number
    [
      "    Test Case     \n" \
      "==================\n" \
      "Number: 123\n" \
      "  Date: 2018-12-23\n" \
      "------------------\n" \
      "\n" \
      "body\n"
    ].each { |expected| assert_output(expected) { cli('123').call } }
  end

  def test_help
    assert_output(/Usage: test_app/) { cli('-h').call }
  end

  private

  def cli(*args)
    Cli.new('test_app', args).tap do |cli|
      cli.send(:options).instance_variable_set(:@data_dir, fake_fs)
    end
  end

  def fake_fs # rubocop:disable Metrics/MethodLength
    FakeDir.new('/').tap do |fs|
      fs.create_path('en-test/case-123.txt', <<-FABLE)
        Title: Test Case
        Number: 123
        Date: 2018-12-23

        body
      FABLE
      fs.create_path('en-test/case-234.txt', <<-FABLE)
        Title: Test Case 2
        Number: 234
        Date: 2018-12-30

        body 2
      FABLE
    end
  end
end

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

class TestCli < UnitTest # rubocop:disable Metrics/ClassLength
  def setup
    @pager = ENV.delete('PAGER')
  end

  def teardown
    ENV['PAGER'] = @pager
  end

  def test_bad_arguments
    assert_output(nil, /unknown option `--unknown-flag'/) do
      cli('--unknown-flag').call
    end
    assert_output(nil, /Usage: test_app/) do
      cli('--unknown-flag').call
    end
  end

  def test_bad_number
    assert_raises(ArgumentError) { cli('--random-set', 'string').call }
  end

  def test_call_default
    expected = "00123  Test Case\n00234  Test Case 2\n"
    assert_output(expected) { cli.call }
  end

  def test_force_stdout
    expected = "00123  Test Case\n00234  Test Case 2\n"
    assert_output(expected) { cli('-o', '-').call }
  end

  def test_call_single_by_number
    [
      "    Test Case\n" \
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

  def test_version
    assert_output(/^test_app #{VERSION}/) { cli('--version').call }
  end

  def test_list_translations
    assert_output("en  test\n") { cli('--list-translations').call }
  end

  def test_random_stability
    create_cases(10)
    cli = cli('--random')

    first  = capture_io { Random.srand(0) && cli.call }
    second = capture_io { Random.srand(1) && cli.call }
    third  = capture_io { Random.srand(0) && cli.call }

    assert_equal first, third
    refute_equal first, second
  end

  def test_random_set_stability
    create_cases(10)
    cli = cli('--random-set', '10')

    first  = capture_io { Random.srand(0) && cli.call }
    second = capture_io { Random.srand(1) && cli.call }
    third  = capture_io { Random.srand(0) && cli.call }

    assert_equal first, third
    refute_equal first, second
  end

  def test_daily_stability
    create_cases(10)
    cli = cli('--daily')

    first  = capture_io { stub_today('2018-12-23') { cli.call } }
    second = capture_io { stub_today('2000-11-11') { cli.call } }
    third  = capture_io { stub_today('2018-12-23') { cli.call } }

    assert_equal first, third
    refute_equal first, second
  end

  private

  def cli(*args)
    Cli.new('test_app', args).tap do |cli|
      cli.send(:options).instance_variable_set(:@data_dir, fake_fs)
    end
  end

  def fake_fs
    @fake_fs ||= create_fake_fs
  end

  def create_fake_fs # rubocop:disable Metrics/MethodLength
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

  def create_cases(count)
    (100..(100 + count)).each do |num|
      fake_fs.create_path("en/test/case-#{num}.txt", <<-FABLE)
        Title: Case #{num}
        Number: #{num}

        Case #{num}
      FABLE
    end
  end

  def stub_today(date, &blk)
    Date.stub(:today, Date.parse(date), &blk)
  end
end

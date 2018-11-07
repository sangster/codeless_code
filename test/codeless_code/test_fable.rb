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

class TestFable < UnitTest
  def test_read_headers?
    new_fable = fable

    refute_predicate new_fable, :read_headers?
    new_fable.headers
    assert_predicate new_fable, :read_headers?
  end

  def test_headers
    assert_kind_of Hash, fable.headers
    refute_empty fable.headers.keys

    %w[Date Title Number].each do |key|
      assert_includes fable.headers.keys, key
    end
  end

  def test_body
    new_fable = fable

    assert_kind_of String, new_fable.body
    assert_predicate new_fable, :read_headers?
  end

  def test_date
    assert_kind_of Date, fable.date
  end

  def test_lang
    assert_equal :en, fable('en-test').lang
  end

  def test_translator
    assert_equal 'test', fable('en-test').translator
  end

  def test_names
    assert_kind_of Enumerable, fable.names
  end

  def test_topics
    assert_kind_of Enumerable, fable.topics
  end

  private

  def fable(dir = 'en-test', fable = 'case-123.txt', root: fake_fs)
    (@fable ||= {})["#{dir}/#{fable}"] ||=
      Fable.new(root.glob(dir).first.glob(fable).first)
  end

  def fake_fs
    FakeDir.new('/').tap do |fs|
      fs.create_path('en-test/case-123.txt').open do |io|
        io.write(<<-FABLE)
          Title: Test Case
          Number: 123
          Date: 2018-12-23

          body
        FABLE
      end
    end
  end
end

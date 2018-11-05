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

    %w[Date Title Number Geekiness Topics].each do |key|
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
    assert_equal :en, fable('en-qi').lang
  end

  def test_translator
    assert_equal 'qi', fable('en-qi').translator
  end

  def test_names
    assert_kind_of Enumerable, fable.names
  end

  def test_topics
    assert_kind_of Enumerable, fable.topics
  end

  private

  def fable(dir = 'en-qi', fable = 'case-1.txt')
    (@fable ||= {})["#{dir}/#{fable}"] ||=
      Fable.new(DEFAULT_DATA.glob(dir).first.glob(fable).first)
  end
end


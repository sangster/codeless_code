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

class TestFableSet < UnitTest
  def test_lang
    assert_kind_of Symbol, set.lang

    assert_equal :en, set('en-*').lang
    assert_equal :zh, set('zh-*').lang
  end

  def test_translator
    assert_kind_of String, set.translator

    assert_equal 'qi',     set('*-qi').translator
    assert_equal 'hanzik', set('*-hanzik').translator
  end

  def test_fables
    assert_kind_of Enumerable, set.fables

    set.fables.each { |fable| assert_kind_of Fable, fable }
  end

  def test_filter
    all_filter = ->(_fable) { true }

    assert_kind_of Enumerable, set.filter(all_filter)
    set.filter(all_filter).each { |fable| assert_kind_of Fable, fable }
  end

  def test_filter_expected_side
    all_filter = ->(_fable) { true }
    none_filter = ->(_fable) { false }

    assert_equal set.fables.size, set.filter(all_filter).size
    assert_equal 0, set.filter(none_filter).size
  end

  private

  def set(dirname = 'en-qi', root: fake_fs)
    (@set ||= {})[dirname] ||= FableSet.new(root.glob(dirname).first)
  end

  def fake_fs
    FakeDir.new('/').tap do |fs|
      fs.create_path('en-qi/case-123.txt')
      fs.create_path('zh-hanzik/case-123.txt')
    end
  end
end

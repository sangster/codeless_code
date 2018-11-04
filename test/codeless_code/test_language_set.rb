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

class TestLanguageSet < UnitTest
  def test_class_available_languages
    assert_kind_of Enumerable, LanguageSet.available_languages

    LanguageSet.available_languages.each do |lang|
      assert_kind_of Symbol, lang
    end
  end

  def test_lang
    assert_equal :en, set(:en).lang
    assert_equal :zh, set(:zh).lang
  end

  def test_fable_sets
    assert_kind_of Enumerable, set.fable_sets
    refute_empty set.fable_sets
    assert_equal set.fable_sets.size, set.dirs.size

    set.fable_sets.each { |set| assert_kind_of FableSet, set }
  end

  def test_dirs
    assert_kind_of Enumerable, set.dirs

    set.dirs.each do |entry|
      flunk format('%p is not a directory', entry) unless entry.directory?
    end
  end

  private

  def set(lang = :en)
    (@set ||= {})[lang] ||= LanguageSet.new(lang)
  end
end


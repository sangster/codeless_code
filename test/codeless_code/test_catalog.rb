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

class TestCatalog < UnitTest
  def test_languages
    assert_kind_of Enumerable, catalog.languages

    catalog.languages.each { |lang| assert_kind_of Symbol, lang }
  end

  def test_fetch
    assert_kind_of LanguageSet, catalog.fetch(:en)
    assert_equal :en, catalog.fetch(:en).lang
  end

  def test_fetch_not_found
    assert_raises(LanguageSet::NotFoundError) { catalog.fetch(:unknown) }
  end

  def test_language_sets
    assert_kind_of Enumerable, catalog.language_sets
    catalog.language_sets.each { |set| assert_kind_of LanguageSet, set }
  end

  def test_fable_sets
    assert_kind_of Enumerable, catalog.fable_sets
    catalog.fable_sets.each { |set| assert_kind_of FableSet, set }
  end

  def test_fables
    assert_kind_of Enumerable, catalog.fables
    catalog.fables.each { |fable| assert_kind_of Fable, fable }
  end

  def test_select
    all_filter = ->(_fable) { true }

    assert_kind_of Enumerable, catalog.select(all_filter)
    catalog.select(all_filter).each { |fable| assert_kind_of Fable, fable }
  end

  def test_select_expected_size
    all_filter = ->(_fable) { true }
    none_filter = ->(_fable) { false }

    assert_equal catalog.fables.size, catalog.select(all_filter).size
    assert_equal 0, catalog.select(none_filter).size
  end

  private

  def catalog(dir = fake_fs)
    (@catalog ||= {})[dir] ||= Catalog.new(dir)
  end

  def fake_fs
    FakeDir.new('/').tap do |fs|
      fs.create_path('en-test/case-123.txt')
    end
  end
end

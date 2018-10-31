require 'helper'

class TestLanguageSet < UnitTest
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


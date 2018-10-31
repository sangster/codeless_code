require 'helper'

class TestFableSet < UnitTest
  def test_lang
    assert_equal :en, set('en-*').lang
    assert_equal :zh, set('zh-*').lang
  end

  def test_translator
    assert_equal 'qi',     set('*-qi').translator
    assert_equal 'hanzik', set('*-hanzik').translator
  end

  def test_files
    assert_kind_of Enumerable, set.files

    set.files.each do |entry|
      flunk format('%p is not a file', entry) unless entry.file?
    end
  end

  private

  def set(dirname = 'en-qi')
    (@set ||= {})[dirname] ||= FableSet.new(DATA_DIR.glob(dirname).first)
  end
end


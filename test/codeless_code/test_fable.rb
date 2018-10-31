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

  def test_names
    assert_kind_of Enumerable, fable.names
  end

  private

  def fable(dir = 'en-qi', fable = 'case-1.txt')
    (@fable ||= {})["#{dir}/#{fable}"] ||=
      Fable.new(DATA_DIR.glob(dir).first.glob(fable).first)
  end
end


require 'helper'

class TestCodelessCode < UnitTest
  def test_data_dir
    assert_kind_of Pathname, CodelessCode::DATA_DIR
    assert_predicate CodelessCode::DATA_DIR, :frozen?

    assert_predicate CodelessCode::DATA_DIR.glob('*'), :any?
  end
end


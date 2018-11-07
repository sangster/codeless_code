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

module Filters
  class TestBuilders < UnitTest
    def test_header_integer_filter
      assert_kind_of Class, Filters::Builders.header_integer_filter('FooOne')
      assert_kind_of Filters::Headers::Integer,
                     Filters::Builders.header_integer_filter('FooTwo').new
    end

    def test_header_string_filter
      assert_kind_of Class, Filters::Builders.header_string_filter('BarOne')
      assert_kind_of Filters::Headers::String,
                     Filters::Builders.header_string_filter('BarTwo').new
    end
  end
end

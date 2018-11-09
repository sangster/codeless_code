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

module Filters
  class TestComposite < UnitTest
    def test_enabled?
      assert_predicate filter(matching_filter), :enabled?
      assert_predicate filter(matchless_filter), :enabled?
      assert_predicate filter(filter(matching_filter)), :enabled?
    end

    def test_not_enabled?
      refute_predicate filter, :enabled?
      refute_predicate filter(filter(filter)), :enabled?
    end

    def test_call_matching
      assert filter(matching_filter).call(create_fable),
             'Expected composite filter to match'
    end

    def test_call_matchless
      refute filter(matchless_filter).call(create_fable),
             'Expected composite filter to match'
    end

    def test_call_empty
      refute filter.call(create_fable),
             'Expected an empty composite to match nothing'
    end

    private

    def filter(*filters)
      Filters::Composite.new(*filters)
    end

    def matching_filter
      Filters::Number.new(exact: 123)
    end

    def matchless_filter
      Filters::Date.new(exact: '2018')
    end

    def create_fable
      mock_fable(<<-BODY.strip)
        Number: 123

        body
      BODY
    end
  end
end

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
  class TestDate < UnitTest
    def test_enabled?
      refute_predicate filter, :enabled?
      refute_predicate filter(exclude: false), :enabled?

      assert_predicate filter(exact: '2018-12-23'), :enabled?
      assert_predicate filter(min: '2018-12-23'), :enabled?
      assert_predicate filter(max: '2018-12-23'), :enabled?
      assert_predicate filter(exclude: true), :enabled?
    end

    def test_call_exact
      assert_filter(exact: '2018-12-23')

      refute_filter(exact: '1999-12-23')
    end

    def test_call_min
      assert_filter(min: '2018-12-22')
      assert_filter(min: '2018-12-23')

      refute_filter(min: '2018-12-24')
    end

    def test_call_max
      assert_filter(max: '2018-12-23')
      assert_filter(max: '2018-12-24')

      refute_filter(max: '2018-12-22')
    end

    def test_call_exclude
      assert_filter(create_dateless_fable, exclude: true)

      refute_filter(exclude: true)
    end

    private

    def filter(**opts)
      Filters::Date.new(**opts)
    end

    def assert_filter(fab = nil, **opts)
      fab ||= create_fable
      filt = filter(**opts)
      assert filt.call(fab), format('Expected %p to match %p', opts, fab)
    end

    def refute_filter(fab = nil, **opts)
      fab ||= create_fable
      filt = filter(**opts)
      refute filt.call(fab), format('Expected %p not to match %p', opts, fab)
    end

    def create_fable(date = '2018-12-23')
      mock_fable(<<-BODY.strip)
        Number: 123
        Date: #{date}

        body
      BODY
    end

    def create_dateless_fable
      mock_fable(<<-BODY.strip)
        Number: 123

        body
      BODY
    end
  end
end

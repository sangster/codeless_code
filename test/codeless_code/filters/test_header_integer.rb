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
  class TestHeaderInteger < UnitTest
    def test_enabled?
      refute_predicate filter('Test'), :enabled?
      refute_predicate filter('Test', exclude: false), :enabled?

      assert_predicate filter('Test', exact: 1), :enabled?
      assert_predicate filter('Test', min: 1), :enabled?
      assert_predicate filter('Test', max: 1), :enabled?
      assert_predicate filter('Test', exclude: true), :enabled?
    end

    def test_call_exact
      assert_filter(exact: 100)

      refute_filter(exact: 123)
    end

    def test_call_min
      assert_filter(min: 99)
      assert_filter(min: 100)

      refute_filter(min: 101)
    end

    def test_call_max
      assert_filter(max: 100)
      assert_filter(max: 101)

      refute_filter(max: 99)
    end

    def test_call_exclude
      assert_filter('MissingHeader', exclude: true)

      refute_filter(exclude: true)
    end

    private

    def filter(key, **opts)
      Filters::HeaderInteger.new(key, **opts)
    end

    def assert_filter(key = 'Test', **opts)
      fab = create_fable
      filt = filter(key, **opts)
      assert filt.call(fab), format('Expected %p to match %p', opts, fab)
    end

    def refute_filter(key = 'Test', **opts)
      fab = create_fable
      filt = filter(key, **opts)
      refute filt.call(fab), format('Expected %p not to match %p', opts, fab)
    end

    def create_fable
      mock_fable(<<-BODY.strip)
        Test: 100

        body
      BODY
    end
  end
end

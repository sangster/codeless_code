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
  module Headers
    class TestString < UnitTest
      def test_enabled?
        refute_predicate filter('Test'), :enabled?
        refute_predicate filter('Test', exclude: false), :enabled?

        assert_predicate filter('Test', exact: 'foo'), :enabled?
        assert_predicate filter('Test', start_with: 'foo'), :enabled?
        assert_predicate filter('Test', end_with: 'foo'), :enabled?
        assert_predicate filter('Test', exclude: true), :enabled?
      end

      def test_call_exact
        assert_filter(exact: 'some text')

        refute_filter(exact: 'something else')
      end

      def test_call_start_with
        assert_filter(start_with: 'some')
        assert_filter(start_with: '')

        refute_filter(start_with: 'something else')
      end

      def test_call_end_with
        assert_filter(end_with: 'text')
        assert_filter(end_with: '')

        refute_filter(end_with: 'something else')
      end

      def test_call_exclude
        assert_filter('MissingHeader', exclude: true)

        refute_filter(exclude: true)
      end

      private

      def filter(key, **opts)
        Filters::Headers::String.new(key, **opts)
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
          Test: some text

          body
        BODY
      end
    end
  end
end

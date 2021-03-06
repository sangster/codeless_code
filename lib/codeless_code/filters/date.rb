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
require 'date'

module CodelessCode
  module Filters
    # Matches {Fable fables} that were published on, before, or after a given
    # date.
    class Date < Headers::Base
      # :reek:BooleanParameter
      def initialize(exact: nil, min: nil, max: nil, exclude: false)
        super('Date', exclude, [Matcher.parse(exact), :==],
                               [Matcher.parse(min),   :<=],
                               [Matcher.parse(max),   :>=])
      end

      # :reek:UtilityFunction
      def parse(val)
        ::Date.parse(val)
      end

      def test_single(val, operator, test)
        test.send(operator, val)
      end

      # Wraps a {::Date} and matches it against "date substrings". ie:
      # +2010-12+ will matches any dates in December, 2010 and +2010+ will
      # match any dates in that year.
      class Matcher
        # param str [String] A date like +2010+, +2010-12+, or +2010-12-23+
        def self.parse(str)
          return nil unless str

          if str.size == 4
            new(::Date.parse("#{str}-01-01"), match: :year)
          elsif str.size == 7
            new(::Date.parse("#{str}-01"), match: :month)
          else
            new(::Date.parse(str), match: :day)
          end
        end

        def initialize(date, match:)
          @date = date
          @match = match
        end

        def ==(other)
          compare(@date, other, :==, @match)
        end

        def >=(other)
          compare(@date, other, :>=, @match)
        end

        def <=(other)
          compare(@date, other, :<=, @match)
        end

        private

        # :reek:ControlParameter
        # :reek:FeatureEnvy
        def compare(first, second, operator, match)
          case match
          when :year
            first.year.send(operator, second.year)
          when :month
            compare_month(first, second, operator)
          else
            first.send(operator, second)
          end
        end

        # :reek:FeatureEnvy
        def compare_month(first, second, operator)
          if first.year == second.year
            first.month.send(operator, second.month)
          else
            compare(first, second, operator, :year)
          end
        end
      end
    end
  end
end

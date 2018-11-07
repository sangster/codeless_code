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
    class Date
      def initialize(exact: nil, min: nil, max: nil, exclude: false)
        @tests ||= [
          [exact, :==],
          [min,   :>=],
          [max,   :<=]
        ].select(&:first).freeze
        @exclude = exclude
      end

      def enabled?
        @tests.any? || @exclude
      end

      def call(fable)
        if (val = fable.date)
          @tests.any? ? test(val) : !@exclude
        else
          @exclude
        end
      end

      private

      def test(val)
        @tests.any? { |(test, op)| val.send(op, test) }
      end

      class Matcher
        # param str [String] A date like +2010+, +2010-12+, or +2010-12-23+
        def self.parse(str)
          match = :day

          if str.size == 4
            str = "#{str}-01-01"
            match = :year
          elsif str.size == 7
            str = "#{str}-01"
            match = :month
          end

          new(::Date.parse(str), match: match)
        end

        def initialize(date, match:)
          @date = date
          @match = match
        end

        def ==(other)
          cmp(@date, other, :==, @match)
        end

        def >=(other)
          cmp(@date, other, :>=, @match)
        end

        def <=(other)
          cmp(@date, other, :<=, @match)
        end

        private

        def cmp(a, b, op, match)
          case match
          when :year
            a.year.send(op, b.year)
          when :month
            a.year == b.year ? a.month.send(op, b.month) : cmp(a, b, op, :year)
          else
            a.send(op, b)
          end
        end
      end
    end
  end
end

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
module CodelessCode
  module Filters
    class HeaderInteger
      def initialize(key, exact: nil, min: nil, max: nil, exclude: false)
        @key = key
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
        if fable.header?(@key)
          @tests.any? ? test(fable[@key].to_i) : !@exclude
        else
          @exclude
        end
      end

      private

      def test(val)
        @tests.any? { |(test, op)| val.send(op, test) }
      end
    end
  end
end

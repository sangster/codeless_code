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
    class HeaderString
      def initialize(key, exact: nil, start_with: nil, end_with: nil,
                          exclude: false)
        @key = key
        @exact = exact
        @start_with = start_with
        @end_with = end_with
        @exclude = exclude
      end

      def enabled?
        @exact || @start_with || @end_with || @exclude
      end

      def call(fable)
        if fable.header?(@key) && (val = fable[@key])
          return false unless @exact.nil? || val == @exact
          return false unless @start_with.nil? || val.start_with?(@start_with)
          return false unless @end_with.nil? || val.end_with?(@end_with)
          !@exclude
        else
          @exclude
        end
      end
    end
  end
end

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
module CodelessCode
  module Filters
    module Headers
      # Matches {Fable fables} that have an integer header equal to, less than,
      # or greater than the given parameters.
      class Integer < Base
        def initialize(key, exact: nil, min: nil, max: nil, exclude: false)
          super(key, exclude, [exact, :==],
                              [min,   :>=],
                              [max,   :<=])
        end

        protected

        def parse(val)
          val.to_i
        end
      end
    end
  end
end

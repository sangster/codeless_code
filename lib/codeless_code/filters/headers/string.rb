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
      # Matches {Fable fables} that have an string header equal to, that starts
      # with, or ends with the given parameters.
      class String < Base
        # :reek:BooleanParameter
        def initialize(key, exact: nil, start_with: nil, end_with: nil,
                       exclude: false)
          super(key, exclude, [exact,      :==],
                              [start_with, :start_with?],
                              [end_with,   :end_with?])
        end
      end
    end
  end
end

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
    # Module functions to generate filter subclasses.
    module Builders
      module_function

      def header_integer_filter(name)
        subclass_filter(Headers::Integer, name)
      end

      def header_string_filter(name)
        subclass_filter(Headers::String, name)
      end

      def subclass_filter(klass, name)
        const_set(name, Class.new(klass) do
          def initialize(*args)
            super(self.class.name.split(':').last, *args)
          end
        end)
      end
    end
  end
end

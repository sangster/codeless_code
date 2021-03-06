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
      # Abstract base class for all generic filters that test a {Fable fable's}
      # headers.
      class Base
        def initialize(key, exclude, *tests)
          @key = key
          @exclude = exclude
          @tests ||= tests.select(&:first).freeze
        end

        def enabled?
          @tests.any? || @exclude
        end

        def call(fable)
          if fable.header?(@key)
            @tests.any? ? test(parse(fable[@key])) : !@exclude
          else
            @exclude
          end
        end

        protected

        # :reek:UtilityFunction
        def parse(val)
          val
        end

        def test_single(val, operator, test)
          val.send(operator, test)
        end

        private

        def test(val)
          @tests.any? { |(test, op)| test_single(val, op, test) }
        end
      end
    end
  end
end

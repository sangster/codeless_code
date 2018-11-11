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
require 'mediacloth'

module CodelessCode
  module Formats
    # Prints the {Fable} without any formatting, but removes the markup.
    class Plain < Base
      def call
        raw.split("\n\n")
           .map { |str| from_wiki(CleanupBody.new(str)) }
           .join("\n\n")
      end

      protected

      def from_wiki(str)
        super(XhtmlDoc.parse(str.to_s), :Plain)
      end
    end

    # Tidies up the mixed syntax found in fables
    class CleanupBody
      def initialize(body)
        @body = body
      end

      def to_s
        [
          [%r{\s*//\w*$}, ''],
          [%r{<i>([^<]+)</i>}mi, '\1'],
          [%r{<b>([^<]+)</b>}mi, '\1'],
          [%r{<a[^>]+>([^<]+)</a>}mi, '\1'],
          [%r{/(\w+)/}, '\1']
        ].inject(@body) { |str, args| str.gsub(*args) }
      end
    end
  end
end

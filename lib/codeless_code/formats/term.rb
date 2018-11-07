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
require 'colorized_string'
require 'mediacloth'

module CodelessCode
  module Formats
    # Renders the {Fable} using ANSI control characters for bold, italics,
    # colors, etc.
    class Term < Base
      def call
        from_wiki
      end

      # :reek:UtilityFunction
      def color(str)
        ColorizedString.new(str)
      end

      protected

      def from_wiki
        super(XhtmlDoc.parse(regex_raw), :Term)
      end

      private

      def regex_raw
        [
          [%r{//\w*$}, ''],
          [/^\|   .*/, ColorizedString.new('\\0').green],
          [%r{<i>([^<]+)</i>}mi, "''\\1''"],
          [%r{<b>([^<]+)</b>}mi, "'''\\1'''"],
          [%r{<a[^>]+>([^<]+)</a>}mi, '[[\1]]'],
          [%r{/(\w+)/}, "''\\1''"]
        ].inject(raw) { |str, args| str.gsub(*args) }
      end
    end
  end
end

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
    class Plain < Base
      def call
        raw.split("\n\n")
           .map { |str| from_wiki(to_xhtml(regex(str))) }
           .join("\n\n")
      end

      private

      def regex(str)
        [
          [/\/\/\w*$/, ''],
          [/<i>([^<]+)<\/i>/mi, '\1'],
          [/<b>([^<]+)<\/b>/mi, '\1'],
          [/<a[^>]+>([^<]+)<\/a>/mi, '\1'],
          [/\/(\w+)\//, '\1'],
        ].inject(str) { |str, args| str = str.gsub(*args) }
      end

      def from_wiki(str)
        super(str, PlainGenerator.new(self))
      end
    end
  end
end

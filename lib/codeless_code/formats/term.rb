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
require 'nokogiri'

module CodelessCode
  module Formats
    class Term < Base
      def call
        raw.split("\n\n")
           .map { |str| generate(regex(to_xhtml(str))) }
           .join("\n\n")
      end

      def to_xhtml(str)
        # MediaCloth expects XHTML-ish pages and chokes on ommited end tags
        Nokogiri::HTML(str).css('body > *').to_xhtml
      end

      def regex(str)
        [
          [%r{//$}, ''],
          [/^\|   .*/, c('\\0').green],
          [/<i>([^<]+)<\/i>/mi, "''\\1''"],
          [/<b>([^<]+)<\/b>/mi, "'''\\1'''"],
          [/<a[^>]+>([^<]+)<\/a>/mi, '[[\1]]'],
          # [/\/([^\/]*[^<])\//, "''\\1''"],
        ].inject(str) { |str, args| str = str.gsub(*args) }
      end

      def generate(str)
        return "" if str.length == 0
        MediaCloth::wiki_to_html(str, generator: TermGenerator.new(self))
      end

      def c(str)
        ColorizedString.new(str)
      end
    end
  end
end

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
require 'nokogiri'

module CodelessCode
  module Formats
    class Base
      attr_accessor :raw

      def initialize(raw)
        @raw = raw
      end

      protected

      def to_xhtml(str)
        # MediaCloth expects XHTML-ish pages and chokes on ommited end tags
        Nokogiri::HTML(str).css('body > *').to_xhtml
      end

      def from_wiki(str, generator)
        return "" if str.length == 0
        MediaCloth::wiki_to_html(str, generator: generator)
      end
    end
  end
end

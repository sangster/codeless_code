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
require 'nokogiri'

module CodelessCode
  module Formats
    # Abstract base class for all formats.
    class Base
      attr_reader :raw

      def initialize(raw)
        @raw = raw
      end

      protected

      def from_wiki(doc, parser_name)
        parser = Parsers.const_get(parser_name).new(self)
        MediaCloth.wiki_to_html(doc.to_s, generator: parser)
      end
    end

    # MediaCloth expects XHTML-ish pages and chokes on ommited end tags
    class XhtmlDoc
      def self.parse(html)
        new(Nokogiri::HTML(html))
      end

      def initialize(doc)
        @doc = doc
      end

      def to_s
        @doc.css('body > *').to_xhtml
      end
    end
  end
end

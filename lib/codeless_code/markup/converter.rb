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
  module Markup
    CONTAINER_HTML = {
      'blockquote' => Nodes::Quote,
      'b' => Nodes::Bold,
      'div' => Nodes::Para,
      'em' => Nodes::Em,
      'h2' => Nodes::Header,
      'i' => Nodes::Em,
      'li' => Nodes::Quote,
      'main' => Nodes::Doc,
      'nobr' => Nodes::Em,
      'ol' => Nodes::Para,
      'p' => Nodes::Para,
      'php' => Nodes::Quote,
      'table' => Nodes::Para,
      'tr' => Nodes::Para,
      'td' => Nodes::Para,
      'pre' => Nodes::Quote,
      'span' => Nodes::Para,
      'strong' => Nodes::Bold,
      'img' => Nodes::Bold,
      'sup' => Nodes::Reference,
      'tt' => Nodes::Bold,
      'ul' => Nodes::Para
    }.freeze

    # Converts {Nokogiri} elements to {Nodes::Node} elements
    class Converter
      def initialize(elem)
        @elem = elem
      end

      # @return [Nodes::Node]
      def call
        convert_elem(@elem)
      end

      private

      # :reek:FeatureEnvy
      def convert_elem(elem)
        if elem.text?
          elem.content
        elsif (type = CONTAINER_HTML[elem.name])
          type.new(convert_children(elem))
        else
          convert_special(elem)
        end
      end

      def convert_children(elem)
        elem.children.map { |ch| self.class.new(ch).call }
      end

      def convert_special(elem)
        case elem.name
        when 'a' then convert_link(elem)
        when 'br' then Nodes::LineBreak.new
        when 'hr' then Nodes::Rule.new
        else
          raise format('Unexpected: %p', elem)
        end
      end

      def convert_link(elem)
        Nodes::Link.new(elem['href'], convert_children(elem))
      end
    end
  end
end

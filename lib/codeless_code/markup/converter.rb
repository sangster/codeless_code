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
      'p' => Nodes::Para,
      'strong' => Nodes::Bold,
      'sup' => Nodes::Reference,
      'tt' => Nodes::Bold
    }.freeze

    # Converts {Nokogiri} elements to {Markup::Node} elements
    class Converter
      def initialize(elems)
        @elems = elems
      end

      def call
        @elems.map do |elem|
          if elem.text?
            elem.content
          elsif (type = CONTAINER_HTML[elem.name])
            type.new(self.class.new(elem.children).call)
          else
            convert_complex(elem)
          end
        end
      end

      private

      def convert_complex(elem)
        case elem.name
        when 'a' then convert_link(elem)
        when 'br' then Nodes::LineBreak.new
        when 'hr' then Nodes::Rule.new
        when 'span' then self.class.new(elem.children).call
        else
          raise format('Unexpected: %p', elem)
        end
      end

      def convert_link(elem)
        Nodes::Link.new(elem['href'], self.class.new(elem.children).call)
      end
    end
  end
end

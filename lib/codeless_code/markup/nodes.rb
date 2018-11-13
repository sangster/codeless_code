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
    module Nodes
      ELEM_CONTAINERS = %i[Para Quote Bold Em Reference Header].freeze
      ELEM_VOID = %i[LineBreak Rule].freeze

      def convert_html(elems)
        elems.map do |elem|
          if elem.text?
            elem.content
          else
            case elem.name
            when 'a' then Link.new(elem['href'], convert_html(elem.children))
            when 'blockquote' then Quote.new(convert_html(elem.children))
            when 'br' then LineBreak.new
            when 'b' then Bold.new(convert_html(elem.children))
            when 'div' then Para.new(convert_html(elem.children))
            when 'em' then Em.new(convert_html(elem.children))
            when 'h2' then Header.new(convert_html(elem.children))
            when 'hr' then Rule.new
            when 'i' then Em.new(convert_html(elem.children))
            when 'p' then Para.new(convert_html(elem.children))
            when 'span' then convert_html(elem.children)
            when 'strong' then Bold.new(convert_html(elem.children))
            when 'sup' then Reference.new(convert_html(elem.children))
            when 'tt' then Bold.new(convert_html(elem.children))
            else
              raise format('Unexpected: %p', elem)
            end
          end
        end
      end
      module_function :convert_html

      class Node
        def initialize(children = nil)
          @children = children
        end

        def to_s
          children.map(&:to_s).join
        end

        def children
          @children || []
        end
      end

      ELEM_CONTAINERS.each do |name|
        const_set(name, Class.new(Node))
      end

      ELEM_VOID.each do |name|
        const_set(name, Class.new(Node) do
          def initialize
            super()
          end
        end)
      end

      class Link < Node
        attr_reader :href

        def initialize(href = nil, children = [])
          super(children)
          @href = href
        end
      end
    end
  end
end

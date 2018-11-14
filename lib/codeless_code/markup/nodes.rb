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
    # Elements representing the markup of a Fable
    # :reek:ModuleInitialize
    module Nodes
      ELEM_CONTAINERS = %i[Para Quote Bold Em Reference Header].freeze
      ELEM_VOID = %i[LineBreak Rule].freeze

      # An element in the syntax tree
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

      # A hyperlink. Either +<a href=""></a>+, +[[label]]+, or +[[label|url]]+
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

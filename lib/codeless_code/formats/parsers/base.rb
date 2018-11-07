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
    module Parsers
      class Base < MediaWikiWalker
        # Reimplement these
        #
        # @example
        #   def parse_paragraph(ast)
        #     parse_wiki_ast(ast)
        #   end
        ABSTRACT_METHODS = %i[
          parse_paragraph
          parse_paste
          parse_formatted
          parse_list_item
          parse_list_term
          parse_list_definition
          parse_preformatted
          parse_section
          parse_link
          parse_internal_link
          parse_internal_link_item
          parse_table
          parse_table_row
          parse_table_cell
          parse_element
          parse_template
          parse_category
          parse_keyword
        ].freeze

        def initialize(ctx)
          @ctx = ctx
        end

        protected

        def parse_wiki_ast(ast)
          super(ast).join
        end

        ABSTRACT_METHODS.each do |meth|
          define_method(meth) { |ast| parse_wiki_ast(ast) }
        end

        # Reimplement this
        def parse_text(ast)
          ast.contents
        end

        # Reimplement this
        def parse_list(ast)
          ast.children.map(&method(:parse_list_child))
        end

        # Reimplement this
        def parse_resource_link(ast)
          ast.children.map do |c|
            parse_internal_link_item(c) if c.is_a?(InternalLinkItemAST)
          end
        end

        # Reimplement this
        def parse_category_link(ast)
          ast.children.map do |c|
            parse_internal_link_item(c) if c.is_a?(InternalLinkItemAST)
          end
        end

        private

        def parse_list_child(c)
          case c
          when ListItemAST       then parse_list_item(c)
          when ListTermAST       then parse_list_term(c)
          when ListDefinitionAST then parse_list_definition(c)
          end
        end
      end
    end
  end
end

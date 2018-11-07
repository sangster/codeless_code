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
          def initialize(ctx)
            @ctx = ctx
          end

          protected

          def parse_wiki_ast(ast)
            super(ast).join
          end

          #Reimplement this
          def parse_paragraph(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_paste(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_formatted(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_text(ast)
            ast.contents
          end

          #Reimplement this
          def parse_list(ast)
            ast.children.map(&method(:parse_list_child))
          end

          #Reimplement this
          def parse_list_item(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_list_term(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_list_definition(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_preformatted(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_section(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_link(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_internal_link(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_resource_link(ast)
            ast.children.map do |c|
              parse_internal_link_item(c) if c.is_a?(InternalLinkItemAST)
            end
          end

          #Reimplement this
          def parse_category_link(ast)
            ast.children.map do |c|
              parse_internal_link_item(c) if c.is_a?(InternalLinkItemAST)
            end
          end

          #Reimplement this
          def parse_internal_link_item(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_table(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_table_row(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_table_cell(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_element(ast)
            parse_wiki_ast(ast)
          end

          #Reimplement this
          def parse_template(ast)
            ast.template_name
          end

          #Reimplement this
          def parse_category(ast)
            raise NotImplementedError
          end

          #Reimplement this
          def parse_keyword(ast)
            parse_wiki_ast(ast)
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

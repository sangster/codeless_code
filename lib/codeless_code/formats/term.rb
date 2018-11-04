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

module CodelessCode
  module Formats
    class Term < Base
      def call
        raw.split("\n\n")
            .map { |str| generate(regex(str)) }
            .join("\n\n")
      end

      def regex(str)
        [
          [%r{//$}, ''],
          [/^\|   .*/, c('\\0').green],
          [/<i>([^<]+)<\/i>/mi, "''\\1''"],
          [/<b>([^<]+)<\/b>/mi, "'''\\1'''"],
          [/<a[^>]+>([^<]+)<\/a>/mi, '[[\1]]'],
          [/\/([^\/]*[^<])\//, "''\\1''"],
        ].inject(str) { |str, args| str = str.gsub(*args) }
      end

      def generate(str)
        MediaCloth::wiki_to_html(str, generator: Generator.new(self))
      end

      def c(str)
        ColorizedString.new(str)
      end

      class Generator < MediaWikiWalker
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
          if ast.formatting == :Bold
            c(parse_wiki_ast(ast)).bold
          else
            c(parse_wiki_ast(ast)).italic
          end
        end

        #Reimplement this
        def parse_text(ast)
          ast.contents
        end

        #Reimplement this
        def parse_list(ast)
          ast.children.map do |c|
            r = parse_list_item(c) if c.class == ListItemAST
            r = parse_list_term(c) if c.class == ListTermAST
            r = parse_list_definition(c) if c.class == ListDefinitionAST
            r
          end
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
          c(parse_wiki_ast(ast)).green
        end

        #Reimplement this
        def parse_section(ast)
          c(parse_wiki_ast(ast).strip).blue
        end

        #Reimplement this
        def parse_link(ast)
          c(parse_wiki_ast(ast)).underline
        end

        #Reimplement this
        def parse_internal_link(ast)
          text = parse_wiki_ast(ast)
          c(text.size > 0 ? text : ast.locator).underline
        end

        #Reimplement this
        def parse_resource_link(ast)
          binding.pry
          ast.children.map do |c|
            parse_internal_link_item(c) if c.class == InternalLinkItemAST
          end
        end

        #Reimplement this
        def parse_category_link(ast)
          binding.pry
          ast.children.map do |c|
            parse_internal_link_item(c) if c.class == InternalLinkItemAST
          end
        end

        #Reimplement this
        def parse_internal_link_item(ast)
          binding.pry
          parse_wiki_ast(ast)
        end

        #Reimplement this
        def parse_table(ast)
          binding.pry
          parse_wiki_ast(ast)
        end

        #Reimplement this
        def parse_table_row(ast)
          binding.pry
          parse_wiki_ast(ast)
        end

        #Reimplement this
        def parse_table_cell(ast)
          binding.pry
          parse_wiki_ast(ast)
        end

        #Reimplement this
        def parse_element(ast)
          str = parse_wiki_ast(ast)
          if ast.name == 'pre'
            c(@ctx.generate(str.gsub(/\A\n*(.*?)\n*\z/m, '\1'))).red
          else
            str
          end
        end

        #Reimplement this
        def parse_template(ast)
          c(ast.template_name).yellow
        end

        #Reimplement this
        def parse_category(ast)
          raise NotImplementedError
        end

        #Reimplement this
        def parse_keyword(ast)
          c(parse_wiki_ast(ast)).underline
        end

        private

        def c(str)
          @ctx.c(str)
        end
      end
    end
  end
end

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
      class Term < Base
          protected

          def parse_formatted(ast)
            if ast.formatting == :Bold
              c(parse_wiki_ast(ast)).bold
            else
              c(parse_wiki_ast(ast)).italic
            end
          end

          def parse_preformatted(ast)
            c(parse_wiki_ast(ast)).green
          end

          def parse_section(ast)
            c(parse_wiki_ast(ast).strip).blue
          end

          def parse_link(ast)
            c(parse_wiki_ast(ast)).underline
          end

          def parse_internal_link(ast)
            text = parse_wiki_ast(ast)
            c(text.size > 0 ? text : ast.locator).underline
          end

          def parse_element(ast)
            str = parse_wiki_ast(ast)
            if ast.name == 'pre'
              c(@ctx.generate(str.gsub(/\A\n*(.*?)\n*\z/m, '\1'))).red
            else
              str
            end
          end

          def parse_template(ast)
            c(ast.template_name).yellow
          end

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

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
      class Plain < Base
          protected

          def parse_section(ast)
            parse_wiki_ast(ast).strip
          end

          def parse_internal_link(ast)
            text = parse_wiki_ast(ast)
            text.size > 0 ? text : ast.locator
          end

          def parse_element(ast)
            str = parse_wiki_ast(ast)
            if ast.name == 'pre'
              @ctx.generate(str.gsub(/\A\n*(.*?)\n*\z/m, '\1'))
            else
              str
            end
          end
      end
    end
  end
end

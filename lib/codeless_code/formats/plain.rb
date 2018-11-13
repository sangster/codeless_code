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
  module Formats
    # Prints the {Fable} without any formatting, but removes the markup.
    class Plain < Base
      def call
        par = Markup::Parser.new(raw).call
        Markup::Nodes.convert_html(par).map(&method(:render)).join.strip
      end

      private

      def render(node)
        case node
        when Markup::Nodes::Bold
          render_children(node)
        when Markup::Nodes::Em
          render_children(node)
        when Markup::Nodes::Reference
          format('[%s]', render_children(node))
        when Markup::Nodes::Header
          inner = render_children(node)
          format("%s\n%s", inner, '-' * inner.length) + "\n\n"
        when Markup::Nodes::LineBreak
          "\n"
        when Markup::Nodes::Link
          render_children(node)
        when Markup::Nodes::Para
          render_children(node) + "\n\n"
        when Markup::Nodes::Quote
          render_children(node).lines
                               .map { |line| "\t" + line }
                               .join + "\n\n"
        when Markup::Nodes::Rule
          '- - - - - - - - - -' + "\n\n"
        when String
          node
        else
          raise format('Unexpected %s: %p', node.class, node)
        end
      end
    end
  end
end

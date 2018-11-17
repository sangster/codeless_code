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
      include Markup::Nodes

      def call
        main = Markup::Parser.new(raw).call
        render(Markup::Converter.new(main).call).rstrip
      end

      private

      def render(node)
        render_leaf(node) || render_container(node) ||
          raise(format('Unexpected %s: %p', node.class, node))
      end

      # :reek:UtilityFunction
      def render_leaf(node)
        case node
        when String    then node
        when LineBreak then "\n"
        when Rule      then '- - - - - - - - -' + "\n\n"
        end
      end

      def render_container(node)
        case node
        when Doc, Bold, Em, Link then render_children(node)
        when Reference           then format('[%s]', render_children(node))
        when Header              then render_header(node)
        when Para                then render_children(node) + "\n\n"
        when Quote               then render_quote(node)
        end
      end

      def render_header(node)
        inner = render_children(node)
        format("%s\n%s", inner, '-' * inner.length) + "\n\n"
      end

      def render_quote(node)
        render_children(node).lines
                             .map { |line| "\t" + line }
                             .join + "\n\n"
      end
    end
  end
end

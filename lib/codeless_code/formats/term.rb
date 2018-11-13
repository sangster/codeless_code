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
require 'colorized_string'

module CodelessCode
  module Formats
    # Renders the {Fable} using ANSI control characters for bold, italics,
    # colors, etc.
    class Term < Base
      def call
        par = Markup::Parser.new(raw).call
        Markup::Nodes.convert_html(par).map(&method(:render)).join.strip
      end

      private

      def render(node)
        case node
        when Markup::Nodes::Bold
          color(render_children(node)).bold
        when Markup::Nodes::Em
          color(render_children(node)).italic
        when Markup::Nodes::Reference
          color(render_children(node)).yellow
        when Markup::Nodes::Header
          inner = render_children(node)
          color(format("%s\n%s", inner, '-' * inner.length)).blue + "\n\n"
        when Markup::Nodes::LineBreak
          "\n"
        when Markup::Nodes::Link
          color(render_children(node)).underline
        when Markup::Nodes::Para
          render_children(node) + "\n\n"
        when Markup::Nodes::Quote
          render_children(node).lines
                               .map { |line| "\t" + color(line).green }
                               .join + "\n\n"
        when Markup::Nodes::Rule
          format("%s\n\n", color('- - - - - - - - - -').yellow)
        when String
          node
        else
          raise format('Unexpected %s: %p', node.class, node)
        end
      end

      # :reek:UtilityFunction
      def color(str)
        ColorizedString.new(str.to_s)
      end
    end
  end
end

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
      include Markup::Nodes

      def call
        par = Markup::Parser.new(raw).call
        Markup::Converter.new(par).call.map(&method(:render)).join.strip
      end

      private

      def render(node)
        render_leaf(node) || render_container(node) || render_style(node) ||
          raise(format('Unexpected %s: %p', node.class, node))
      end

      def render_leaf(node)
        case node
        when String    then node
        when LineBreak then "\n"
        when Rule      then format("%s\n\n", color('- - - - - - - - -').yellow)
        end
      end

      def render_style(node)
        case node
        when Bold      then color(render_children(node)).bold
        when Em        then color(render_children(node)).italic
        when Reference then color(render_children(node)).yellow
        end
      end

      def render_container(node)
        case node
        when Header then render_header(node)
        when Link   then color(render_children(node)).underline
        when Para   then render_children(node) + "\n\n"
        when Quote  then render_quote(node)
        end
      end

      def render_header(node)
        inner = render_children(node)
        color(format("%s\n%s", inner, '-' * inner.length)).blue + "\n\n"
      end

      def render_quote(node)
        render_children(node).lines
                             .map { |line| "\t" + color(line).green }
                             .join + "\n\n"
      end

      # :reek:UtilityFunction
      def color(str)
        ColorizedString.new(str.to_s)
      end
    end
  end
end

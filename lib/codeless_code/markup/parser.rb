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
require 'nokogiri'

module CodelessCode
  module Markup
    class Parser
      # [[href|title]] or [[title]]
      LINK_PATTERN = /\[\[(?:([^|]+)\|)?([^\]]+)\]\]/.freeze

      ITALIC_PATTERN = %r{/([^/]+)/}.freeze  # /some text/
      SUP_PATTERN = /{{([^}]+)}}/.freeze     # {{*}}
      HR_PATTERN = /^- - -(?: -)*$/.freeze   # - - -
      BR_PATTERN = %r{\s*//\s*(?:\n|$)}m.freeze    # end of line //

      attr_reader :doc

      def initialize(str)
        @doc = Nokogiri::HTML(format('<main>%s</main>', str))
      end

      def call
        paragraphs.map do |para|
          parse_paragraph(para) unless para.inner_html.empty?
        end.compact
      end

      private

      def paragraphs
        doc.css('body')
           .children
           .flat_map(&method(:split_double_newline))
           .reject { |node| node.inner_html.empty? }
      end

      def split_double_newline(para)
        body = para.text? ? para.to_s : para.inner_html
        paras = body.split(/\n\n+/)

        case paras.size
        when 0
          new_elem(:span) << ''
        when 1
          if para.name == 'p' || para.name == 'div'
            para
          else
            new_elem(:p) << para
          end
        else
          str_node_set(format('<p><p>%s</p></p>',
                              body.gsub(/\n\n+/, '</p><p>')))
        end
      end

      def new_elem(name)
        Nokogiri::XML::Element.new(name.to_s, doc)
      end

      def str_node_set(str)
        Nokogiri::HTML(format('<main>%s</main>', str)).css('body > main')
                           .tap { |ns| ns.document = doc }
                           .children
      end

      def parse_paragraph(para)
        html = para.inner_html

        if HR_PATTERN =~ html
          new_elem(:hr)
        elsif blockquote?(html)
          new_blockquote(html)
        elsif html.lstrip.start_with?('== ')
          new_elem(:h2) << html.lstrip[3..-1]
        else
          parse_node(para)
        end
      end

      # Does every line start with the same number of spaces?
      def blockquote?(html)
        match = /^\s+/.match(html)
        return unless match

        html.lines.all? { |line| line.start_with?(match[0]) }
      end

      def new_blockquote(html)
        match = /^\s+/.match(html)
        len = match[0].length
        span = new_elem(:span) << html.lines.map { |line| line[len..-1] }.join
        new_elem(:blockquote) << parse_node(span.child)
      end

      # @return [NodeSet]
      def parse_node(node)
        nodes =
          if node.text?
            parse_text(node)
          else
            node.children
                .map(&method(:parse_node))
                .inject(new_elem(node.name)) { |elem, child| elem << child }
          end
        nodes
        # new_elem(:span) << nodes
      end

      def parse_text(text_node)
        text = text_node.content.dup
        text = text.split(BR_PATTERN).map do |str|
                 str.gsub(ITALIC_PATTERN) { new_elem(:em) << $1 }
               end.join("//\n")

        text.gsub!(BR_PATTERN) { new_elem(:br) }
        text.gsub!(SUP_PATTERN) { new_elem(:sup) << $1 }
        gsub_links!(text)
        text.tr!("\n", ' ')
        str_node_set(text)
        # text_node.content.tap do |text|
        #   text.gsub!(BR_PATTERN) { new_elem(:br) }
        #   text.gsub!(ITALIC_PATTERN) { new_elem(:em) << $1 }
        #   text.gsub!(SUP_PATTERN) { new_elem(:sup) << $1 }
        #   gsub_links!(text)
        #   text.tr!("\n", ' ')
        # end
      end

      def gsub_links!(text)
        text.gsub!(LINK_PATTERN) do
          (new_elem(:a) << $2).tap do |link|
            link['href'] = $1 if $1
          end
        end
      end
    end
  end
end

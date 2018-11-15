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
    # Parses the body of a {Fable}, including HTML, MediaWiki syntax, and custom
    # syntax, and returns it as an HTML DOM.
    class Parser
      # [[href|title]] or [[title]]
      LINK_PATTERN = /\[\[(?:([^|]+)\|)?([^\]]+)\]\]/.freeze

      ITALIC_PATTERN = %r{/([^/]+)/}.freeze        # /some text/
      SUP_PATTERN = /{{([^}]+)}}/.freeze           # {{*}}
      HR_PATTERN = /^- - -(?: -)*$/.freeze         # - - -
      BR_PATTERN = %r{\s*//\s*(?:\n|$)}m.freeze    # end of line //

      attr_reader :doc

      def initialize(str)
        @doc = Nokogiri::HTML(format('<main>%s</main>', str))
      end

      # @return [Nokogiri::XML::Element] The body of the fable, with non-HTML
      #   markup converted into HTML
      def call
        new_elem(:main).tap do |main|
          paragraphs.each do |para|
            main << parse_paragraph(para) unless para.inner_html.empty?
          end
        end
      end

      private

      def paragraphs
        @paragraphs ||=
          doc.css('main')
             .flat_map(&method(:split_double_newline))
             .reject { |node| node.inner_html.empty? }
      end

      def split_double_newline(para)
        body = para.text? ? para.to_s : para.inner_html

        case body.split(/\n\n+/).size
        when 0 then new_elem(:span) << ''
        when 1 then split_single_line(para)
        else
          str_node_set(format('<p>%s</p>', body.gsub(/\n\n+/, '</p><p>')))
        end
      end

      def split_single_line(para)
        case para.name
        when 'p'    then para
        when 'main' then new_elem(:p) << para.children
        else
          new_elem(:p) << para
        end
      end

      def new_elem(name)
        Nokogiri::XML::Element.new(name.to_s, doc)
      end

      def str_node_set(str)
        doc = Nokogiri::HTML(format('<main>%s</main>', str))
        doc.css('body > main').tap { |ns| ns.document = doc }.children
      end

      def parse_paragraph(para)
        html = para.inner_html

        if HR_PATTERN.match?(html)
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
      # :reek:UtilityFunction
      def blockquote?(html)
        match = /^\s+/.match(html)
        return unless match

        lines = html.lines
        lines.size > 1 && lines.all? { |line| line.start_with?(match[0]) }
      end

      def new_blockquote(html)
        match = /^\s+/.match(html)
        len = match[0].length
        span = new_elem(:span) << html.lines.map { |line| line[len..-1] }.join
        new_elem(:blockquote) << parse_node(span.child)
      end

      # @return [NodeSet]
      def parse_node(node)
        return parse_text(node) if node.text?

        node.children
            .map(&method(:parse_node))
            .inject(new_elem(node.name)) { |elem, child| elem << child }
      end

      def parse_text(text_node)
        str_node_set(
          gsub_links(
            parse_slashes(text_node.content.dup)
            .gsub(BR_PATTERN) { new_elem(:br) }
            .gsub(SUP_PATTERN) { new_elem(:sup) << Regexp.last_match(1) }
          ).tr("\n", ' ')
        )
      end

      def parse_slashes(text)
        text.split(BR_PATTERN).map do |str|
          str.gsub(ITALIC_PATTERN) { new_elem(:em) << Regexp.last_match(1) }
        end.join("//\n")
      end

      def gsub_links(text)
        text.gsub(LINK_PATTERN) do
          (new_elem(:a) << Regexp.last_match(2)).tap do |link|
            link['href'] = Regexp.last_match(1) if Regexp.last_match(1)
          end
        end
      end
    end
  end
end

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
  module Renderers
    class Page
      PAGER_FORMAT = [
        '%<title>s', '%<sep1>s', '%<headers>s', '%<sep2>s', '', '%<body>s'
      ].join("\n").freeze

      attr_accessor :title, :body

      def initialize(max_width: nil)
        @max_width = max_width || term_width
        @headers = {}
        @key_width = 0
      end

      def to_s
        format(PAGER_FORMAT, title: title.center(width),
                             sep1: seperator('='), sep2: seperator('-'),
                             headers: header_section, body: body)
      end

      def add_header(key, value)
        @key_width = [@key_width, key.size].max
        @headers[key] = value
      end

      private

      def term_width
        if (w = %x[tput cols].strip&.to_i)&.positive?
          w
        end
      rescue Errno::ENOENT
        nil
      end

      def seperator(ch = '=')
        (@seperator ||= {})[ch] ||= ch * width
      end

      def header_section
        lines = @headers.map { |k, v| format_header(k, v, wrap: true) }
        max_line_width = lines.join("\n").lines.map { |s| s.size }.max
        padding = [0, (width - max_line_width)].max / 2

        lines.map { |s| [' ' * padding, s].join }.join("\n")
      end

      def format_header(k, v, wrap: false)
        line =
          if wrap
            v.chars
             .each_slice(width - @key_width - 2)
             .map { |s| s.join.strip }
             .inject { |str, s| str << "\n" << ' ' * (@key_width + 2) << s }
          else
            v
          end

        format("% #{@key_width}s: %s", k, line)
      end

      def width
        @width ||= [content_width, @max_width].compact.min
      end

      def content_width
        [
          body.lines.map do |s|
            ColorizedString[s].uncolorize.strip.size
          end.max || 0,
          @headers.map(&method(:format_header)).map(&:size).max || 0
        ].max
      end
    end
  end
end

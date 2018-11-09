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
  module Renderers
    # Attempts to format the output for the +PAGER+ such that it fits within
    # the bounds of the terminal window.
    class TermPage
      PAGER_FORMAT = [
        '%<title>s', '%<sep1>s', '%<headers>s', '%<sep2>s', '', '%<body>s'
      ].join("\n").freeze

      # :reek:Attribute
      attr_accessor :title, :body
      attr_reader :headers

      # :reek:ControlParameter
      def initialize(max_width: nil, width_func: nil)
        @max_width = max_width
        @max_width ||= (width_func || TermWidth.new).call

        @headers = {}
        @key_width = 0
      end

      def to_s
        format(PAGER_FORMAT, title: title.center(width).rstrip,
                             sep1: seperator('='), sep2: seperator('-'),
                             headers: header_section, body: body)
      end

      def add_header(key, value)
        @key_width = [@key_width, key.size].max
        @headers[key] = value
      end

      private

      def seperator(char = '=')
        (@seperator ||= {})[char] ||= char * width
      end

      def header_section
        lines = format_header_section
        max_line_width = lines.join("\n").lines.map(&:size).max || 0
        padding = [0, (width - max_line_width)].max / 2

        lines.map { |line| [' ' * padding, line].join }.join("\n")
      end

      def format_header_section
        headers.map { |key, value| format_header(key, wrap_header(value)) }
      end

      def format_header(key, value)
        format("% #{@key_width}s: %s", key, value)
      end

      def wrap_header(head)
        head.chars
            .each_slice(width - @key_width - 2)
            .map { |str| str.join.strip }
            .inject { |str, part| str + "\n" + ' ' * (@key_width + 2) + part }
      end

      def width
        @width ||= [content_width, @max_width].compact.min
      end

      def content_width
        [
          body.lines.map do |line|
            ColorizedString[line].uncolorize.strip.size
          end.max || 0,
          headers.map(&method(:format_header)).map(&:size).max || 0
        ].max
      end
    end

    # Ask an external application how wide our terminal is
    class TermWidth
      def initialize(cmd = 'tputs cols')
        @cmd = cmd
      end

      def call
        if (tput_width = `#{@cmd}`.strip.to_i).positive?
          tput_width
        end
      rescue Errno::ENOENT
        nil
      end
    end
  end
end

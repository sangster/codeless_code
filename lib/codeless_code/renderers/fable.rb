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
  module Renderers
    # Prints a {Fable} is various ways.
    class Fable < SimpleDelegator
      HEADER_SORT = %w[Tagline Number Date].freeze

      def for_pager(format, fallback: nil)
        TermPage.new.tap do |page|
          page.title = best_title
          page.body = render_with(format, fallback: fallback)

          headers_no_best_title.map { |key, val| page.add_header(key, val) }
        end
      end

      def for_list(head_keys = [], title_width: '')
        format("%s  %#{title_width}s    %s",
               wide_number, best_title, render_slice(head_keys)).strip
      end

      def best_title
        return title_with_subtitle if title&.size&.positive?

        self['Name'] || self['Tagline'] || inspect
      end

      private

      def render_slice(keys)
        headers.slice(*keys)
               .map { |key, val| format('%s: %p', key, val) }
               .join(', ')
      end

      def render_with(format, fallback:)
        format.new(body).call
      rescue StandardError => err
        raise err unless fallback

        warn format('Error parsing %s: %s', file, err.message.strip)
        fallback.new(body).call
      end

      def title_with_subtitle
        [self['Series'], title, self['Subtitle']].compact.join(': ')
      end

      def headers_no_best_title
        sorted_headers.dup.delete_if { |_, val| val&.strip == title&.strip }
      end

      def sorted_headers
        Hash[
          headers.each_with_index.sort_by do |(key, _), index|
            HEADER_SORT.index(key) || HEADER_SORT.size + index
          end.map(&:first)
        ]
      end

      def wide_number(width: 5)
        number.zero? ? ' ' * width : format("%0#{width}d", number)
      end
    end
  end
end

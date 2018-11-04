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
    class Fable < SimpleDelegator
      HEADER_SORT = %w[Tagline Number Date].freeze

      def for_pager(format, fallback: Formats::Raw)
        Page.new.tap do |page|
          page.title = best_title
          page.body = render_with(format, fallback: fallback)

          headers_no_best_title.map { |k, v| page.add_header(k, v) }
        end
      end

      def for_list
        format('%s  %s', wide_number, best_title)
      end

      private

      def render_with(format, fallback: nil)
        format.new(body).call
      rescue => e
        raise e unless fallback
        warn format('Error parsing %s: %s', file, e.message.strip)
        fallback.new(body).call
      end

      def best_title
        return title_with_subtitle if title&.size&.positive?

        self['Name'] || self['Tagline'] || inspect
      end

      def title_with_subtitle
        [self['Series'], title, self['Subtitle']].compact.join(': ')
      end

      def headers_no_best_title
        sorted_headers.dup.delete_if { |_, v| v&.strip == title&.strip }
      end

      def sorted_headers
        Hash[
          headers.each_with_index.sort_by do |(k,_), i|
            HEADER_SORT.index(k) || HEADER_SORT.size + i
          end.map(&:first)
        ]
      end

      def wide_number(width: 5)
        number.zero? ? ' ' * width : format("%0#{width}d", number)
      end
    end
  end
end

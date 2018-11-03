module CodelessCode
  module Renderers
    class Fable < SimpleDelegator
      HEADER_SORT = %w[Tagline Number Date].freeze

      def for_pager(format = Formats::Raw)
        Page.new.tap do |page|
          page.title = best_title
          page.body = format.new(body).call

          headers_no_best_title.map { |k, v| page.add_header(k, v) }
        end
      end

      def for_list
        format('%s  %s', wide_number, best_title)
      end

      private

      def best_title
        return title_with_subtitle if title&.size&.positive?

        self['Name'] || self['Tagline'] || inspect
      end

      def title_with_subtitle
        [self['Series'], title].compact.join(': ')
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

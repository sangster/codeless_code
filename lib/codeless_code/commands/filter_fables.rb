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
  module Commands
    # Filters down a {Catalog} of {Fable Fables} with criteria specified via
    # the CLI. The results will be listed line-by-line, unless only one fable
    # is found. In that case, it will be printed out.
    class FilterFables
      attr_reader :options

      # @param io [IO] if given, the output will be written to this stream,
      #   otherwise we will attempt to invoke the user's PAGER app
      def initialize(catalog, options, io: nil)
        @catalog = catalog
        @options = options
        @io = io
      end

      def call(&blk)
        fables = filters_from_options(&blk)

        case fables.size
        when 0
          warn 'None found.'
        when 1
          show(fables.first)
        else
          list(fables)
        end
      end

      private

      def filters_from_options
        filter = Filters::FromOptions.new(options)
        fables = @catalog.select(filter)
        fables = yield fables if block_given?
        sort(fables)
      end

      def sort(fables)
        if options.key?(:sort)
          fables = fables.sort_by { |fable| fable[options[:sort]] || "\uffff" }
        end
        fables = fables.reverse if options[:reverse]
        fables
      end

      def show(fable)
        if @io.nil? && ENV.key?('PAGER')
          pager(ENV['PAGER'], fable)
        else
          puts for_pager(fable)
        end
      end

      def pager(cmd, fable)
        io = IO.popen(cmd, 'w')
        io.puts for_pager(fable)
      ensure
        io&.close
      end

      def for_pager(fable)
        render(fable).for_pager(output_format, fallback: fallback_filter)
      end

      def output_format
        case options[:format]
        when 'plain' then Formats::Plain
        when 'raw'   then Formats::Raw
        else              Formats::Term
        end
      end

      def fallback_filter
        options[:trace] ? nil : Formats::Raw
      end

      def list(fables)
        width = title_width(fables)

        fables.each do |fable|
          puts render(fable).for_list(options[:headers], title_width: width)
        end
      end

      def title_width(fables)
        if options[:columns]
          -fables.map { |fable| render(fable).best_title.size }.compact.max
        else
          ''
        end
      end

      # :reek:UtilityFunction
      def render(fable)
        Renderers::Fable.new(fable)
      end

      def puts(str)
        (@io || $stdout).puts(str)
      end
    end
  end
end

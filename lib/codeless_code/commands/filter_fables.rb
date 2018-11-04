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
    class FilterFables
      # @param io [IO] if given, the output will be written to this stream,
      #   otherwise we will attempt to invoke the user's PAGER app
      def initialize(filter, format, io: nil, fallback_filter: Formats::Raw)
        @filter = filter
        @format = format
        @io = io
        @fallback_filter = fallback_filter
      end

      def call
        fables = filtered_fables
        fables = yield fables if block_given?

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

      # @return [Enumerable<Fable>]
      def filtered_fables
        Catalog.new.select(@filter)
      end

      def show(fable)
        if @io.nil? && ENV.key?('PAGER')
          pager(ENV['PAGER'], fable)
        else
          puts render(fable).for_pager(@format, fallback: @fallback_filter)
        end
      end

      def pager(cmd, fable)
        io = open format('|%s', cmd), 'w'
        pid = io.pid

        io.write render(fable).for_pager(@format, fallback: @fallback_filter)
        io.close
      end

      def list(fables)
        fables.each { |fable| puts render(fable).for_list }
      end

      def render(fable)
        Renderers::Fable.new(fable)
      end

      def puts(str)
        (@io || $stdout).puts(str)
      end
    end
  end
end

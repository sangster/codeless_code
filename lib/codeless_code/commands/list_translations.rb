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
    class ListTranslations
      # @param io [IO] if given, the output will be written to this stream,
      #   otherwise STDOUT will be used
      def initialize(io: nil)
        @io = io
      end

      def call
        Catalog.new.language_sets.each do |set|
          translators = set.fable_sets.map(&:translator).sort
          puts format('%s  %s', set.lang, translators.join(', '))
        end
      end

      private

      def puts(str)
        (@io || $stdout).puts(str)
      end
    end
  end
end

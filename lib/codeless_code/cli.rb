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
  class Cli
    def initialize(command_name = $0, args = ARGV)
      @command_name = command_name
      @args = args
    end

    def call
      if options.key?(:help)
        warn options.help
      elsif options.key?(:list_translations)
        Commands::ListTranslations.new.call
      else
        filter_fables
      end
    end

    private

    def filter_fables
      filter = Filters::FromOptions.new(options)

      Commands::FilterFables.new(filter, format).call(&method(:select))
    end

    def options
      @options ||= Options.new(@command_name, @args)
    end

    def format
      case options[:format]
      when 'raw' then Formats::Raw
      else Formats::Term
      end
    end

    def select(fables)
      # binding.pry
      select_rand(fables)
    end

    def select_rand(fables)
      if options[:daily]
        fables.sample(1, random: Random.new(Date.today.strftime('%Y%m%d').to_i))
      elsif (count = options[:random_set])
        if count&.to_i&.to_s != count
          raise ArgumentError, format('not a number %p', count)
        end
        fables.sample(count&.to_i)
      elsif options[:random]
        fables.sample(1)
      else
        fables
      end
    end
  end
end

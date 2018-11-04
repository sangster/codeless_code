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
require 'date'
require 'slop'

module CodelessCode
  class Cli
    def initialize(command_name = $0, args = ARGV)
      @command_name = command_name
      @args = args
    end

    def call
      io = io_open

      if options.key?(:help)
        (io || $stdout).puts options.help
      elsif options.key?(:version)
        (io || $stdout).puts version_str
      elsif options.key?(:list_translations)
        Commands::ListTranslations.new(catalog, io: io).call
      else
        filter_fables(io)
      end

    rescue Slop::Error => e
      warn format("%s\n\n%s", e, options.help)
      exit 1
    ensure
      io&.close
    end

    private

    def filter_fables(io)
      filter = Filters::FromOptions.new(options)
      fallback = options[:trace] ? nil : Formats::Raw

      cmd = Commands::FilterFables.new(filter, output_format, io: io,
                                       fallback_filter: fallback)
      cmd.call(catalog, &method(:select))
    end

    def options
      @options ||= Options.new(@command_name, @args)
    end

    def catalog
      @catalog ||= Catalog.new(options.data_dir)
    end

    def io_open
      if (path = options[:output])
        path == '-' ? $stdout.dup : File.open(path, 'w')
      end
    end

    def output_format
      case options[:format]
      when 'raw' then Formats::Raw
      else Formats::Term
      end
    end

    def select(fables)
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

    def version_str
      format("%s %s\n\n%s\n\nSee <%s>", @command_name, VERSION,
             copyright_summary, 'https://github.com/sangster/codeless_code')
    end

    def copyright_summary
      template = [
        'Copyright (C) %<date>d  Jon Sangster',
        'License GPL-3.0: GNU General Public License v3.0 <%<url>s>',
        'This is free software: you are free to change and redistribute it.',
        'There is NO WARRANTY, to the extent permitted by law.',
      ].join("\n")

      format(template, date: ::Date.today.year,
                       url: 'http://gnu.org/licenses/gpl.html')
    end
  end
end

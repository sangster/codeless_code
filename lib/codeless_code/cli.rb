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
require 'date'
require 'slop'

module CodelessCode
  # Parse command-line parameters and dispatch them to the user's chosen
  # "command."
  class Cli
    def initialize(command_name = $PROGRAM_NAME, args = ARGV)
      @command_name = command_name
      @args = args
    end

    def call
      user_io = io_open
      call_io(user_io)
    rescue Slop::Error => err
      warn format("%s\n\n%s", err, options.help)
      exit 1
    ensure
      user_io&.close
    end

    private

    def call_io(user_io)
      if options.key?(:help)
        io_puts(user_io, options.help)
      elsif options.key?(:version)
        io_puts(user_io, version_str)
      elsif options.key?(:list_translations)
        list_translations(user_io)
      else
        filter_fables(user_io)
      end
    end

    # :reek:ControlParameter
    # :reek:UtilityFunction
    def io_puts(io, *args)
      (io || $stdout).puts(*args)
    end

    def options
      @options ||= Options.new(@command_name, @args)
    end

    def list_translations(user_io)
      Commands::ListTranslations.new(catalog, io: user_io).call
    end

    def filter_fables(user_io)
      Commands::FilterFables.new(catalog, options, io: user_io)
                            .call(&method(:select_rand))
    end

    def catalog
      @catalog ||= Catalog.new(options.data_dir)
    end

    # @return [IO,nil] the user's chosen output stream. +nil+ if unspecified
    # :reek:FeatureEnvy
    def io_open
      path = options[:output]
      return if path.nil?

      path == '-' ? $stdout.dup : File.open(path, 'w')
    end

    # @return [Enumerable<Fable>] a random subset of the given collection, as
    #   specified by {#options}
    def select_rand(fables)
      if options[:daily]
        fables.sample(1, random: date_random_generator)
      elsif (count = options[:random_set])
        assert_num!(count)
        fables.sample(count&.to_i)
      elsif options[:random]
        fables.sample(1)
      else
        fables
      end
    end

    # :reek:UtilityFunction
    def date_random_generator
      Random.new(::Date.today.strftime('%Y%m%d').to_i)
    end

    def assert_num!(num)
      return unless assert_num(num)

      raise ArgumentError, format('not a number %p', num)
    end

    # :reek:UtilityFunction
    def assert_num(num)
      num&.to_i&.to_s != num
    end

    def version_str
      format(['%s %s', '%s', 'See <%s>'].join("\n\n"), @command_name, VERSION,
             copyright_summary, 'https://github.com/sangster/codeless_code')
    end

    def copyright_summary
      template = [
        'Copyright (C) %<date>d  Jon Sangster',
        'License GPL-3.0: GNU General Public License v3.0 <%<url>s>',
        'This is free software: you are free to change and redistribute it.',
        'There is NO WARRANTY, to the extent permitted by law.'
      ].join("\n")

      format(template, date: ::Date.today.year,
                       url: 'http://gnu.org/licenses/gpl.html')
    end
  end
end

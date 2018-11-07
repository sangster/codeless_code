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
require 'forwardable'
require 'slop'

module CodelessCode
  # Adapter class for ARGV which exposes the command-line arguments as data
  # types.
  class Options
    extend Forwardable
    include Enumerable

    MAX_ARGS = 1 # --number flag may be passed as argument +cmd 3+ vs +cmd -N 3+

    def_delegators :opts, :to_hash, :[]
    def_delegators :to_hash, :each, :slice

    def initialize(command_name, argv)
      @command_name = command_name
      @argv = argv
    end

    def opts
      @opts ||= parse_opts(suppress_errors: false)
    end

    def args
      opts.arguments[1..-1]
    end

    def key?(key)
      !!self[key]
    end

    # @return [Pathname] Where on the file system to search for fables. Will
    #   default to {CodelessCode.DEFAULT_DATA} if unspecified
    def data_dir
      @data_dir ||= self[:path] ? Pathname.new(self[:path]) : DEFAULT_DATA
    end

    # @return [String] a description of the supported command-line options
    def help
      parse_opts(suppress_errors: true).to_s
    end

    private

    def parse_opts(suppress_errors:)
      args = [@command_name] + @argv
      opts = CodelessCode::OPTIONS.curry[@command_name]

      Slop.parse(args, suppress_errors: suppress_errors, &opts).tap do |opt|
        if !suppress_errors && opt.arguments.size > MAX_ARGS + 1
          raise format('too many arguments: %p', opt.arguments[1..-1])
        end
      end
    end
  end
end

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
require 'slop'

module CodelessCode
  class Options
    extend Forwardable
    include Enumerable

    def_delegators :opts, :to_hash, :[]
    def_delegators :to_hash, :each, :slice

    def initialize(command_name, argv)
      @command_name = command_name
      @argv = argv
    end

    def opts(suppress: false)
      @opts ||=
        begin
          args = [@command_name] + @argv
          opts = CodelessCode::OPTIONS.curry[@command_name]

          Slop.parse(args, suppress_errors: suppress, &opts).tap do |opt|
            if !suppress && opt.arguments.size > 2
              raise format('too many arguments: %p', opt.arguments[1..-1])
            end
          end
        end
    end

    def key?(key)
      !!self[key]
    end

    def help
      opts(suppress: true).to_s
    end

    def args
      opts.arguments[1..-1]
    end
  end
end

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

module CodelessCode
  class FableSet
    extend Forwardable
    include Enumerable

    attr_accessor :dir
    def_delegator :fables, :each

    def initialize(dir)
      self.dir = dir
    end

    def lang
      @lang ||= name_parts.first.to_sym
    end

    def translator
      @translator ||= name_parts.last
    end

    def fables
      @fables ||= files.map { |f| Fable.new(f) }.sort_by(&:number)
    end

    def filter(filt)
      select { |f| filt.call(f) }
    end

    private

    def files
      dir.glob('*.txt')
    end

    def name_parts
      dir.basename.to_s.split('-')
    end
  end
end

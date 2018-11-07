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

module CodelessCode
  # An {Enumerable collection} of {FableSet fable sets} in a given language, but
  # possibly translated by the different people.
  class LanguageSet
    extend Forwardable
    include Enumerable

    NotFoundError = Class.new(StandardError)

    LANG_PATTERN = '%s-*'

    attr_accessor :lang, :root_dir
    def_delegator :fable_sets, :each

    def initialize(lang, root_dir:)
      self.lang = lang
      self.root_dir = root_dir
    end

    def fable_sets
      dirs.map { |dir| FableSet.new(dir) }
    end

    private

    def dirs
      root_dir.glob(format(LANG_PATTERN, lang)).select(&:directory?)
    end
  end
end

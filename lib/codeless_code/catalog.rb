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
  class Catalog
    # extend Forwardable
    include Enumerable

    attr_accessor :root_dir

    def initialize(root_dir: DEFAULT_DATA)
      self.root_dir = root_dir
    end

    def languages
      @languages ||= root_dir.glob('*-*')
                             .select(&:directory?)
                             .map { |dir| dir.basename.to_s.split('-').first }
                             .uniq
                             .map(&:to_sym)
                             .sort
    end

    # @return [LanguageSet]
    def fetch(lang)
      if languages.include?(lang)
        LanguageSet.new(lang)
      else
        raise LanguageSet::NotFoundError,
              format("No fables for language %p", lang)
      end
    end

    def language_sets
      languages.map { |lang| LanguageSet.new(lang) }
    end

    def fable_sets
      language_sets.flat_map(&:fable_sets)
    end

    def fables
      fable_sets.flat_map(&:fables)
    end

    def select(filter)
      fables.select { |fable| filter.call(fable) }.sort_by(&:number)
    end
  end
end

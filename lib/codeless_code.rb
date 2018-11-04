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
require 'pathname'

module CodelessCode
  autoload  :Catalog,      'codeless_code/catalog'
  autoload  :Cli,          'codeless_code/cli'
  autoload  :Fable,        'codeless_code/fable'
  autoload  :FableSet,     'codeless_code/fable_set'
  autoload  :Filters,      'codeless_code/filters'
  autoload  :LanguageSet,  'codeless_code/language_set'
  autoload  :Options,      'codeless_code/options'

  module Commands
    autoload  :FilterFables,      'codeless_code/commands/filter_fables'
    autoload  :ListTranslations,  'codeless_code/commands/list_translations'
  end

  module Formats
    autoload  :Base,           'codeless_code/formats/base'
    autoload  :Raw,            'codeless_code/formats/raw'
    autoload  :Term,           'codeless_code/formats/term'
    autoload  :TermGenerator,  'codeless_code/formats/term_generator'
  end

  module Renderers
    autoload  :Fable,  'codeless_code/renderers/fable'
    autoload  :Page,   'codeless_code/renderers/page'
  end

  VERSION = Pathname.new(__dir__).join('..', 'VERSION').read.strip.freeze
  DEFAULT_DATA = Pathname.new(__dir__)
                     .join('..', 'data', 'the-codeless-code').freeze

  BANNERS = [
    '%<cmd>s [INFO]',
    '',
    '%<cmd>s [OPTION]... [FILTER]... [NUMBER]'
  ].freeze

  OPTIONS = proc do |cmd, o|
    banner = [[BANNERS[0]] + BANNERS[1..-1].map { |s| "\n       #{s}" }].join

    o.banner = format("Usage: #{banner}", cmd: cmd)
    o.separator ''
    o.separator 'Print or filter Codeless Code fables.'

    o.separator ''
    o.separator 'Info'
    o.boolean '-h', '--help'
    o.boolean '--list-translations'
    o.boolean '--version'

    o.separator ''
    o.separator 'Options'
    o.string '-o', '--output', 'write to the given file. "-" for STDOUT'
    o.string '-f', '--format', 'one of: raw, term (default)'
    o.string '-p', '--path', 'path to directory of fables. ' \
                             'see github.com/aldesantis/the-codeless-code'
    o.boolean '--random', 'select one fable, randomly, from the filtered list'
    o.string '--random-set', 'select n fables, randomly, from the filtered list'
    o.boolean '--daily', 'select one fable, randomly, from the filtered list' \
                         'based on today\'s date'
    o.boolean '--trace', 'print full error message if a fable fails to parse'

    o.separator ''
    o.separator 'Series Filters'
    o.string '-S', '--series'
    o.string '-Ss', '--series-start', 'series starts with'
    o.string '-Se', '--series-end', 'series ends with'
    o.boolean '-hS', '--has-series', 'has series listed'
    o.boolean '-nS', '--no-series', 'no series listed'

    o.separator ''
    o.separator 'Title Filters'
    o.string '-T', '--title'
    o.string '-Ts', '--title-start', 'title starts with'
    o.string '-Te', '--title-end', 'title ends with'
    o.boolean '-hT', '--has-title', 'has title listed'
    o.boolean '-nT', '--no-title', 'no title listed'

    o.separator ''
    o.separator 'Number Filters'
    o.string '-N', '--number', 'number (this is the default argument)'
    o.string '-Ng', '--number-gte', 'number or greater'
    o.string '-Nl', '--number-lte', 'number or lower'
    o.boolean '-hN', '--has-number', 'has number listed'
    o.boolean '-nN', '--no-number', 'no number listed'

    o.separator ''
    o.separator 'Language Filters'
    o.string '-L', '--lang', 'language code (default: en)'

    o.separator ''
    o.separator 'Translator Filters'
    o.string '-r', '--translator', 'translator\'s name (default: first ' \
      'one, alphabetically)'
    o.string '-R', '--translator-exact', 'translator\'s name, ' \
      'case-sensitive (default: first one, alphabetically)'

    o.separator ''
    o.separator 'Date Filters'
    o.string '-D', '--date', 'publish date'
    o.string '-Da', '--date-after', 'publish date or after'
    o.string '-Db', '--date-before', 'publish date or before'
    o.boolean '-nD', '--no-date', 'no publish date listed'

    o.separator ''
    o.separator 'Geekiness Filters'
    o.string '-G', '--geekiness', 'geekiness rating'
    o.string '-Gg', '--geekiness-gte', 'geekiness rating or greater'
    o.string '-Gl', '--geekiness-lte', 'geekiness rating or lower'
    o.boolean '-nG', '--no-geekiness', 'no geekiness rating'

    o.separator ''
    o.separator 'Name Filters'
    o.string '-A', '--name'
    o.string '-As', '--name-start', 'name starts with'
    o.string '-Ae', '--name-end', 'name ends with'
    o.boolean '-nA', '--no-name', 'no name listed'

    o.separator ''
    o.separator 'Credits Filters'
    o.string '-C', '--credits'
    o.string '-Cs', '--credits-start', 'credits starts with'
    o.string '-Ce', '--credits-end', 'credits ends with'
    o.boolean '-hC', '--has-credits', 'has credits listed'
    o.boolean '-nC', '--no-credits', 'no credits listed'

    o.separator ''
    o.separator 'Tagline Filters'
    o.string '-I', '--tagline'
    o.string '-Is', '--tagline-start', 'tagline starts with'
    o.string '-Ie', '--tagline-end', 'tagline ends with'
    o.boolean '-hI', '--has-tagline', 'has tagline listed'
    o.boolean '-nI', '--no-tagline', 'no tagline listed'
  end
end

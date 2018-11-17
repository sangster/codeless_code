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
require 'pathname'

# +CodelessCode+ filters and renders {Fable fables}.
module CodelessCode
  autoload  :Catalog,      'codeless_code/catalog'
  autoload  :Cli,          'codeless_code/cli'
  autoload  :Fable,        'codeless_code/fable'
  autoload  :FableSet,     'codeless_code/fable_set'
  autoload  :Filters,      'codeless_code/filters'
  autoload  :LanguageSet,  'codeless_code/language_set'
  autoload  :Options,      'codeless_code/options'

  # The "main" methods this applications supports.
  module Commands
    autoload  :FilterFables,      'codeless_code/commands/filter_fables'
    autoload  :ListTranslations,  'codeless_code/commands/list_translations'
  end

  # The methods in which {Fable fables} may be rendered as text.
  module Formats
    autoload  :Base,            'codeless_code/formats/base'
    autoload  :Plain,           'codeless_code/formats/plain'
    autoload  :Raw,             'codeless_code/formats/raw'
    autoload  :Term,            'codeless_code/formats/term'
  end

  # Parses the markup in a {Fable}
  module Markup
    autoload  :Converter,  'codeless_code/markup/converter'
    autoload  :Nodes,      'codeless_code/markup/nodes'
    autoload  :Parser,     'codeless_code/markup/parser'
  end

  # The methods in which a {Fable fables's} body may be rendered as text.
  module Renderers
    autoload  :Fable,     'codeless_code/renderers/fable'
    autoload  :TermPage,  'codeless_code/renderers/term_page'
  end

  VERSION = Pathname.new(__dir__).join('..', 'VERSION').read.strip.freeze
  DEFAULT_DATA = Pathname.new(__dir__)
                         .join('..', 'data', 'the-codeless-code').freeze

  BANNERS = [
    '%<cmd>s [INFO]',
    '',
    '%<cmd>s [OPTION]... [FILTER]... [NUMBER]'
  ].freeze

  OPTIONS = proc do |cmd, opt|
    banner =
      [[BANNERS[0]] + BANNERS[1..-1].map { |str| "\n       #{str}" }].join

    opt.banner = format("Usage: #{banner}", cmd: cmd)
    opt.separator ''
    opt.separator 'Print or filter Codeless Code fables.'

    opt.separator ''
    opt.separator 'Info'
    opt.boolean '-h', '--help'
    opt.boolean '--list-translations'
    opt.boolean '--version'

    opt.separator ''
    opt.separator 'Options'
    opt.boolean '-c', '--columns', 'when listing fables, format the output ' \
                                   'into columns'
    opt.array '-e', '--headers', 'headers to include in the list output. ' \
                                 'may be repeated'
    opt.string '-f', '--format', 'one of: raw, plain, or term (default)'
    opt.string '-o', '--output', 'write to the given file. "-" for STDOUT'
    opt.string '-p', '--path', 'path to directory of fables. ' \
                               'see github.com/aldesantis/the-codeless-code'
    opt.boolean '--random', 'select one random fable from the filtered list'
    opt.string '--random-set', 'select n random fables from the filtered list'
    opt.boolean '--daily', 'select one fable, randomly, from the filtered ' \
                           'list based on today\'s date'
    opt.boolean '--trace', 'print full error message if a fable fails to parse'

    opt.string '-s', '--sort', 'when listing fables, sort by the given header'
    opt.boolean '-r', '--reverse', 'when listing fables, reverse the order'

    opt.separator ''
    opt.separator 'Series Filters'
    opt.string '-S', '--series'
    opt.string '-Ss', '--series-start', 'series starts with'
    opt.string '-Se', '--series-end', 'series ends with'
    opt.boolean '-hS', '--has-series', 'has series listed'
    opt.boolean '-nS', '--no-series', 'no series listed'

    opt.separator ''
    opt.separator 'Title Filters'
    opt.string '-T', '--title'
    opt.string '-Ts', '--title-start', 'title starts with'
    opt.string '-Te', '--title-end', 'title ends with'
    opt.boolean '-hT', '--has-title', 'has title listed'
    opt.boolean '-nT', '--no-title', 'no title listed'

    opt.separator ''
    opt.separator 'Number Filters'
    opt.string '-N', '--number', 'number (this is the default argument)'
    opt.string '-Ng', '--number-gte', 'number or greater'
    opt.string '-Nl', '--number-lte', 'number or lower'
    opt.boolean '-hN', '--has-number', 'has number listed'
    opt.boolean '-nN', '--no-number', 'no number listed'

    opt.separator ''
    opt.separator 'Language Filters'
    opt.string '-L', '--lang', 'language code (default: en)'

    opt.separator ''
    opt.separator 'Translator Filters'
    opt.string '-R', '--translator', 'translator\'s name (default: first ' \
                                     'one, alphabetically)'
    opt.string '-Rx', '--translator-exact',
               'translator\'s name, case-sensitive (default: first one, ' \
               'alphabetically)'

    opt.separator ''
    opt.separator 'Date Filters'
    opt.string '-D', '--date', 'publish date'
    opt.string '-Da', '--date-after', 'publish date or after'
    opt.string '-Db', '--date-before', 'publish date or before'
    opt.boolean '-nD', '--no-date', 'no publish date listed'

    opt.separator ''
    opt.separator 'Geekiness Filters'
    opt.string '-G', '--geekiness', 'geekiness rating'
    opt.string '-Gg', '--geekiness-gte', 'geekiness rating or greater'
    opt.string '-Gl', '--geekiness-lte', 'geekiness rating or lower'
    opt.boolean '-nG', '--no-geekiness', 'no geekiness rating'

    opt.separator ''
    opt.separator 'Name Filters'
    opt.string '-A', '--name'
    opt.string '-As', '--name-start', 'name starts with'
    opt.string '-Ae', '--name-end', 'name ends with'
    opt.boolean '-nA', '--no-name', 'no name listed'

    opt.separator ''
    opt.separator 'Credits Filters'
    opt.string '-C', '--credits'
    opt.string '-Cs', '--credits-start', 'credits starts with'
    opt.string '-Ce', '--credits-end', 'credits ends with'
    opt.boolean '-hC', '--has-credits', 'has credits listed'
    opt.boolean '-nC', '--no-credits', 'no credits listed'

    opt.separator ''
    opt.separator 'Tagline Filters'
    opt.string '-I', '--tagline'
    opt.string '-Is', '--tagline-start', 'tagline starts with'
    opt.string '-Ie', '--tagline-end', 'tagline ends with'
    opt.boolean '-hI', '--has-tagline', 'has tagline listed'
    opt.boolean '-nI', '--no-tagline', 'no tagline listed'
  end
end

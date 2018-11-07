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
  module Filters
    autoload  :Builders,       'codeless_code/filters/builders'
    autoload  :Composite,      'codeless_code/filters/composite'
    autoload  :Date,           'codeless_code/filters/date'
    autoload  :FromOptions,    'codeless_code/filters/from_options'
    autoload  :HeaderBase,     'codeless_code/filters/header_base'
    autoload  :HeaderInteger,  'codeless_code/filters/header_integer'
    autoload  :HeaderString,   'codeless_code/filters/header_string'
    autoload  :Lang,           'codeless_code/filters/lang'
    autoload  :Translator,     'codeless_code/filters/translator'

    extend Builders

    header_string_filter 'Credits'
    header_string_filter 'Name'
    header_string_filter 'Series'
    header_string_filter 'Tagline'
    header_string_filter 'Title'

    header_integer_filter 'Geekiness'
    header_integer_filter 'Number'
  end
end

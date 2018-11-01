module CodelessCode
  module Filters
    autoload  :Builders,       'codeless_code/filters/builders'
    autoload  :Composite,      'codeless_code/filters/composite'
    autoload  :Date,           'codeless_code/filters/date'
    autoload  :IntegerHeader,  'codeless_code/filters/integer_header'
    autoload  :Lang,           'codeless_code/filters/lang'
    autoload  :StringHeader,   'codeless_code/filters/string_header'
    autoload  :Translator,     'codeless_code/filters/translator'

    extend Builders

    string_header_filter 'Credits'
    string_header_filter 'Name'
    string_header_filter 'Tagline'
    string_header_filter 'Title'

    integer_header_filter 'Geekiness'
    integer_header_filter 'Number'
  end
end

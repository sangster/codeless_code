module CodelessCode
  module Filters
    autoload  :Builders,       'codeless_code/filters/builders'
    autoload  :Composite,      'codeless_code/filters/composite'
    autoload  :Date,           'codeless_code/filters/date'
    autoload  :HeaderInteger,  'codeless_code/filters/header_integer'
    autoload  :Lang,           'codeless_code/filters/lang'
    autoload  :HeaderString,   'codeless_code/filters/header_string'
    autoload  :Translator,     'codeless_code/filters/translator'

    extend Builders

    header_string_filter 'Credits'
    header_string_filter 'Name'
    header_string_filter 'Tagline'
    header_string_filter 'Title'

    header_integer_filter 'Geekiness'
    header_integer_filter 'Number'
  end
end

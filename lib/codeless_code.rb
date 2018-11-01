require 'pathname'

module CodelessCode
  VERSION = '0.0.1'.freeze
  DATA_DIR = Pathname.new(__dir__).join('..', 'data', 'the-codeless-code').freeze

  autoload  :Fable,        'codeless_code/fable'
  autoload  :FableSet,     'codeless_code/fable_set'
  autoload  :Filters,      'codeless_code/filters'
  autoload  :LanguageSet,  'codeless_code/language_set'
end

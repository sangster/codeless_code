require 'slop'

module CodelessCode
  class OptionsParser
    def call(args = ARGV)
      opts = Slop.parse(args, &method(:define_options))
      args = opts.arguments[1..-1]

      if args.size > 1
        warn opts.to_s
        raise format('too many arguments: %p', args)
      end

      Options.new(args, **opts.to_hash)
    end

    private

    def define_options(o)
      o.banner = format('Usage: %s [FILTER]... [NUMBER]', $0)
      o.separator 'Print or filter Codeless Code fables.'

      o.separator ''
      o.separator 'Title Filters'
      o.string '-T', '--title'
      o.string '-Ts', '--title-start', 'title starts with'
      o.string '-Te', '--title-end', 'title ends with'
      o.boolean '-nT', '--no-title', 'no title listed'

      o.separator ''
      o.separator 'Number Filters'
      o.string '-N', '--number', 'number (this is the default argument)'
      o.string '-Ng', '--number-gte', 'number or greater'
      o.string '-Nl', '--number-lte', 'number or lower'
      o.boolean '-nN', '--no-number', 'no number listed'

      o.separator ''
      o.separator 'Language Filters'
      o.string '-l', '-L', '--lang', 'language code (default: en)'

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
      o.boolean '-nC', '--no-credits', 'no credits listed'

      o.separator ''
      o.separator 'Tagline Filters'
      o.string '-I', '--tagline'
      o.string '-Is', '--tagline-start', 'tagline starts with'
      o.string '-Ie', '--tagline-end', 'tagline ends with'
      o.boolean '-nI', '--no-tagline', 'no tagline listed'
    end
  end
end

module CodelessCode
  class Cli
    def initialize(command = 'codeless_code', args = ARGV)
      @command = command
      @args = args
    end

    def call
      fables = filtered_fables

      case fables.size
      when 0
        warn 'None found.'
      when 1
        show(fables.first)
      else
        list(fables)
      end
    end

    private

    def options
      @options ||= OptionsParser.new.call([@command] + @args)
    end

    def filtered_fables
      fable_set.select { |fable| options.composite_filter.call(fable) }
    end

    def fable_set
      language_set.first
    end

    def language_set
      @language_set ||= Catalog.new.fetch(lang)
    end

    def lang
      options.lang
    end

    def show(fable)
      if ENV.key?('PAGER')
        pager(ENV['PAGER'], fable)
      else
        puts render(fable).for_pager
      end
    end

    def pager(cmd, fable)
      io = open format('|%s', cmd), 'w'
      pid = io.pid

      io.write render(fable).for_pager
      io.close
    end

    def list(fables)
      fables.each { |fable| puts render(fable).for_list }
    end

    def render(fable)
      Renderers::Fable.new(fable)
    end
  end
end

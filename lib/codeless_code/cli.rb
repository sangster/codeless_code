module CodelessCode
  class Cli
    def initialize(command_name = $0, args = ARGV)
      @command_name = command_name
      @args = args
    end

    def call
      if options.key?(:help)
        warn options.help
      elsif options.key?(:list_translations)
        Commands::ListTranslations.new.call
      else
        filter_fables
      end
    end

    private

    def filter_fables
      filter = Filters::FromOptions.new(options)
      Commands::FilterFables.new(filter, format).call
    end

    def options
      @options ||= Options.new(@command_name, @args)
    end

    def format
      case options[:format]
      when 'raw' then Formats::Raw
      else Formats::Term
      end
    end
  end
end

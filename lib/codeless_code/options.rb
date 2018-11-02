require 'slop'

module CodelessCode
  class Options
    extend Forwardable

    def_delegators :composite_filter, :call

    def initialize(args, **opts)
      @args = args
      @opts = opts
    end

    def lang
      @opts[:lang]&.to_sym || :en
    end

    def enabled?
      @opts.key?(:lang) || non_defaults_enabled?
    end

    def composite_filter
      Filters::Composite.new(filters)
    end

    def filters
      @filters ||= [
        Filters::Lang.new(exact: lang),

        Filters::Translator.new(exact: @opts[:translator_exact],
                                casecmp: @opts[:translator]),

        Filters::Credits.new(**str_args(:credits)),
        Filters::Name.new(**str_args(:name)),
        Filters::Tagline.new(**str_args(:tagline)),
        Filters::Title.new(**str_args(:title)),

        Filters::Geekiness.new(**int_args(:geekiness)),
        Filters::Number.new(**int_args(:number).tap do |n|
          n[:exact] ||= @args.last&.to_i
        end),

        Filters::Date.new(**date_args),
      ]
    end

    private

    def non_defaults_enabled?
      filters.reject { |f| f.is_a?(Filters::Lang) }.any?(&:enabled?)
    end

    def str_args(name)
      Hash[
        %i[exact start_with end_with exclude].zip(
          @opts.slice(*%I[#{name} #{name}_start #{name}_end no_#{name}]).values
        )
      ]
    end

    def int_args(name)
      Hash[
        %i[exact min max exclude].zip(
          @opts.slice(*%I[#{name} #{name}_gte #{name}_lte])
               .values
               .map { |num| num&.to_i }
               .push(@opts[:"no_#{name}"])
        )
      ]
    end

    def date_args
      {
        exact: date(@opts[:date]),
        min: date(@opts[:date_gte]),
        max: date(@opts[:date_lte]),
        exclude: @opts[:no_date],
      }
    end

    def date(arg)
      Date.parse(arg) if arg
    end
  end
end

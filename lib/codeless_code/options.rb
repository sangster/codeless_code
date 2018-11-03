require 'slop'

module CodelessCode
  class Options
    extend Forwardable
    include Enumerable

    def_delegators :opts, :to_hash, :[]
    def_delegators :to_hash, :each, :slice

    def initialize(command_name, argv)
      @command_name = command_name
      @argv = argv
    end

    def opts
      @opts ||=
        Slop.parse([@command_name] + @argv,
                   &CodelessCode::OPTIONS.curry[@command_name]).tap do |opt|
          if opt.arguments.size > 2
            raise format('too many arguments: %p', opt.arguments[1..-1])
          end
        end
    end

    def key?(key)
      !!self[key]
    end

    def help
      opts.to_s
    end

    def args
      opts.arguments[1..-1]
    end
  end
end

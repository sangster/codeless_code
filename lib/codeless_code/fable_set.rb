module CodelessCode
  class FableSet
    extend Forwardable
    include Enumerable

    attr_accessor :dir
    def_delegator :fables, :each

    def initialize(dir)
      self.dir = dir
    end

    def lang
      @lang ||= name_parts.first.to_sym
    end

    def translator
      @translator ||= name_parts.last
    end

    def fables
      @fables ||= files.map { |f| Fable.new(f) }.sort_by(&:number)
    end

    def filter(filt)
      select { |f| filt.call(f) }
    end

    private

    def files
      dir.glob('*.txt')
    end

    def name_parts
      dir.basename.to_s.split('-')
    end
  end
end

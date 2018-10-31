module CodelessCode
  class FableSet
    attr_accessor :dir

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
      files.map { |f| Fable.new(f) }.sort_by(&:number)
    end

    def files
      dir.glob('*.txt')
    end

    private

    def name_parts
      dir.basename.to_s.split('-')
    end
  end
end

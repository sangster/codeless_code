module CodelessCode
  class LanguageSet
    attr_accessor :lang

    def initialize(lang)
      self.lang = lang
    end

    def fable_sets
      dirs.map { |dir| FableSet.new(dir) }
    end

    def dirs
      DATA_DIR.glob(format('%s-*', lang)).select(&:directory?)
    end
  end
end

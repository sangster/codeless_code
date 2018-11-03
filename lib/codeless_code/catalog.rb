module CodelessCode
  class Catalog
    # extend Forwardable
    include Enumerable

    attr_accessor :root_dir

    def initialize(root_dir: DATA_DIR)
      self.root_dir = root_dir
    end

    def languages
      @languages ||= root_dir.glob('*-*')
                             .select(&:directory?)
                             .map { |dir| dir.basename.to_s.split('-').first }
                             .uniq
                             .map(&:to_sym)
                             .sort
    end

    # @return [LanguageSet]
    def fetch(lang)
      if languages.include?(lang)
        LanguageSet.new(lang)
      else
        raise LanguageSet::NotFoundError,
              format("No fables for language %p", lang)
      end
    end

    def language_sets
      languages.map { |lang| LanguageSet.new(lang) }
    end

    def fable_sets
      language_sets.flat_map(&:fable_sets)
    end

    def fables
      fable_sets.flat_map(&:fables)
    end

    def select(filter)
      fables.select { |fable| filter.call(fable) }.sort_by(&:number)
    end
  end
end

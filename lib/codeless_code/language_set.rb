module CodelessCode
  class LanguageSet
    extend Forwardable
    include Enumerable

    attr_accessor :lang, :root_dir
    def_delegator :fable_sets, :each

    class << self
      def available_languages(root_dir = DATA_DIR)
        root_dir.glob('*-*')
                .select(&:directory?)
                .map { |dir| dir.basename.to_s.split('-').first }
                .uniq
                .map(&:to_sym)
                .sort
      end
    end

    def initialize(lang, root_dir: DATA_DIR)
      self.lang = lang
      self.root_dir = root_dir
    end

    def fable_sets
      dirs.map { |dir| FableSet.new(dir) }
    end

    def dirs
      root_dir.glob(format('%s-*', lang)).select(&:directory?)
    end
  end
end

module CodelessCode
  module Commands
    class ListTranslations
      def call
        Catalog.new.language_sets.each do |set|
          translators = set.fable_sets.map(&:translator).sort
          puts format('%s  %s', set.lang, translators.join(', '))
        end
      end
    end
  end
end

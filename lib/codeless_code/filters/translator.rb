module CodelessCode
  module Filters
    class Translator
      def initialize(exact: nil, casecmp: nil)
        @exact = exact
        @casecmp = casecmp
      end

      def call(fable)
        return false unless @exact.nil? || @exact == fable.translator
        @casecmp.nil? || @casecmp.casecmp?(fable.translator)
      end
    end
  end
end

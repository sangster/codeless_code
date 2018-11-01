module CodelessCode
  module Filters
    class Lang
      def initialize(exact: nil)
        @exact = exact
      end

      def call(fable)
        @exact.nil? || @exact == fable.lang
      end
    end
  end
end

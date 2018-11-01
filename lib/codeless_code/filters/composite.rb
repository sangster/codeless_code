module CodelessCode
  module Filters
    class Composite
      extend Forwardable
      include Enumerable

      def_delegators :@filters, :push, :<<, :[], :each

      def initialize(*filters)
        @filters = filters.flatten
      end

      def call(fable)
        all? { |filter| filter.call(fable) }
      end
    end
  end
end

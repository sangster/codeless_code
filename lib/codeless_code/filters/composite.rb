module CodelessCode
  module Filters
    class Composite
      extend Forwardable
      include Enumerable

      attr_reader :filters
      def_delegators :filters, :push, :<<, :[], :each

      def initialize(*filters)
        @filters = filters.flatten
      end

      def enabled?
        any?(&:enabled?)
      end

      def call(fable)
        select(&:enabled?).all? { |filter| filter.call(fable) }
      end
    end
  end
end

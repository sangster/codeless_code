module CodelessCode
  module Filters
    class IntegerHeader
      def initialize(key, exact: nil, min: nil, max: nil, exclude: false)
        @key = key
        @exact = exact
        @min = min
        @max = max
        @exclude = exclude
      end

      def enabled?
        @exact || @min || @max || @exclude
      end

      def call(fable)
        if fable.header?(@key) && (val = fable[@key]&.to_i)
          return false unless @exact.nil? || val == @exact
          return false unless @min.nil? || val >= @min.to_i
          return false unless @max.nil? || val <= @max.to_i
          true
        else
          @exclude
        end
      end
    end
  end
end

module CodelessCode
  module Filters
    class Date
      def initialize(exact: nil, min: nil, max: nil, exclude: false)
        @exact = exact
        @min = min
        @max = max
        @exclude = exclude
      end

      def call(fable)
        if (date = fable.date)
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

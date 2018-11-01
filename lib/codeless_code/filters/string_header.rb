module CodelessCode
  module Filters
    class StringHeader
      def initialize(key, exact: nil, start_with: nil, end_with: nil,
                          exclude: false)
        @key = key
        @exact = exact
        @start_with = start_with
        @end_with = end_with
        @exclude = exclude
      end

      def call(fable)
        if fable.header?(@key) && (val = fable[@key])
          return false unless @exact.nil? || val == @exact
          return false unless @start_with.nil? || val.start_with?(@start_with)
          return false unless @end_with.nil? || val.end_with?(@end_with)
          true
        else
          @exclude
        end
      end
    end
  end
end

module CodelessCode
  module Filters
    class Date
      def initialize(exact: nil, min: nil, max: nil, exclude: false)
        @exact = exact
        @min = min
        @max = max
        @exclude = exclude
      end

      def enabled?
        @exact || @min || @max || @exclude
      end

      def call(fable)
        if (val = fable.date)
          return false unless @exact.nil? || @exact == val
          return false unless @min.nil? || @min <= val
          return false unless @max.nil? || @max >= val
          true
        else
          @exclude
        end
      end

      class Matcher
        # param str [String] A date like +2010+, +2010-12+, or +2010-12-23+
        def self.parse(str)
          match = :day

          if str.size == 4
            str = "#{str}-01-01"
            match = :year
          elsif str.size == 7
            str = "#{str}-01"
            match = :month
          end

          new(::Date.parse(str), match: match)
        end

        def initialize(date, match:)
          @date = date
          @match = match
        end

        def ==(other)
          cmp(@date, other, :==, @match)
        end

        def >=(other)
          cmp(@date, other, :>=, @match)
        end

        def <=(other)
          cmp(@date, other, :<=, @match)
        end

        private

        def cmp(a, b, op, match)
          binding.pry if !a.is_a?(::Date) || !b.is_a?(::Date)
          case match
          when :year
            a.year.send(op, b.year)
          when :month
            a.year == b.year ? a.month.send(op, b.month) : cmp(a, b, op, :year)
          else
            a.send(op, b)
          end
        end
      end
    end
  end
end

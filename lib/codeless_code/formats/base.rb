module CodelessCode
  module Formats
    class Base
      attr_accessor :raw

      def initialize(raw)
        @raw = raw
      end

      protected

      def formatted
      end
    end
  end
end

module CodelessCode
  module Filters
    module Builders
      module_function

      def integer_header_filter(name)
        subclass_filter(IntegerHeader, name)
      end

      def string_header_filter(name)
        subclass_filter(StringHeader, name)
      end

      def subclass_filter(klass, name)
        const_set(name, Class.new(klass) do
          def initialize(*args)
            super(self.class.class_name, *args)
          end
        end)
      end
    end
  end
end

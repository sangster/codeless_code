module CodelessCode
  module Filters
    module Builders
      module_function

      def header_integer_filter(name)
        subclass_filter(HeaderInteger, name)
      end

      def header_string_filter(name)
        subclass_filter(HeaderString, name)
      end

      def subclass_filter(klass, name)
        const_set(name, Class.new(klass) do
          def initialize(*args)
            super(self.class.name.split(':').last, *args)
          end
        end)
      end
    end
  end
end

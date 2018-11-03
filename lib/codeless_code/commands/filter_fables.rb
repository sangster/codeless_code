module CodelessCode
  module Commands
    class FilterFables
      def initialize(filter, format)
        @filter = filter
        @format = format
      end

      def call
        fables = filtered_fables

        case fables.size
        when 0
          warn 'None found.'
        when 1
          show(fables.first)
        else
          list(fables)
        end
      end

      private

      # @return [Enumerable<Fable>]
      def filtered_fables
        Catalog.new.select(@filter)
      end

      def show(fable)
        if ENV.key?('PAGER')
          pager(ENV['PAGER'], fable)
        else
          puts render(fable).for_pager(@format)
        end
      end

      def pager(cmd, fable)
        io = open format('|%s', cmd), 'w'
        pid = io.pid

        io.write render(fable).for_pager(@format)
        io.close
      end

      def list(fables)
        fables.each { |fable| puts render(fable).for_list }
      end

      def render(fable)
        Renderers::Fable.new(fable)
      end
    end
  end
end

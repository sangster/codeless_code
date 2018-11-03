require 'date'

module CodelessCode
  class Fable
    extend Forwardable

    HEADER_PATTERN = /([^:\s]+)\s*:\s*(.+)\s*$/.freeze

    attr_accessor :file
    attr_reader :read_headers

    alias_method :read_headers?, :read_headers
    def_delegators :headers, :[], :fetch, :key?

    def initialize(file)
      self.file = file
      @read_headers = false
      @body_pos = nil
    end

    def body
      @body ||= read_body.freeze
    end
    alias_method :to_s, :body

    def headers
      @headers ||= begin
                     @read_headers = true
                     read_headers.freeze
                   end
    end

    def header?(key)
      headers.key?(key)
    end

    def date
      Date.parse(self['Date']) if header?('Date')
    end

    def lang
      @lang ||= dir_parts.first.to_sym
    end

    def translator
      @translator ||= dir_parts.last
    end

    def title
      self['Title']
    end

    def tagline
      self['Tagline']
    end

    def credits
      self['Credits']
    end

    def number
      self['Number'].to_i
    end

    def geekiness
      self['Geekiness'].to_i
    end

    def names
      list('Names')
    end

    def topics
      list('Topics')
    end

    private

    def read_body
      headers unless read_headers?

      io = file.open
      io.seek @body_pos
      io.read.strip
    ensure
      io&.close
    end

    def read_headers
      io = file.open

      {}.tap do |head|
        until io.eof?
          @body_pos = io.pos
          if (m = HEADER_PATTERN.match(io.gets))
            head[m[1].strip] = m[2]&.strip
          else
            break
          end
        end

        massage_headers(head)
      end
    ensure
      io&.close
    end

    def massage_headers(head)
      if head.key?('Series')
        head['Series'] = head['Title']
        head['Title'] = head.delete('Subtitle')
      end
    end

    def list(key)
      fetch(key, '').split(',').map(&:strip)
    end

    def dir_parts
      file.parent.basename.to_s.split('-')
    end
  end
end

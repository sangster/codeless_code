# frozen_string_literal: true

# codeless_code filters and prints fables from http://thecodelesscode.com
# Copyright (C) 2018  Jon Sangster
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.
require 'forwardable'
require 'date'

module CodelessCode
  # Model/Adapter for a "Codeless Code" fable stored in a text file.
  class Fable
    extend Forwardable

    HEADER_PATTERN = /([^:\s]+)\s*:\s*(.+)\s*$/.freeze

    attr_reader :file, :has_read_headers

    alias read_headers? has_read_headers
    def_delegators :headers, :[], :fetch, :key?

    def initialize(file)
      @file = file
      @has_read_headers = false
      @body_pos = nil
    end

    # @return [String] the actual story, including MediaWiki markup
    def body
      @body ||= read_body.freeze
    end
    alias to_s body

    # @return [Hash<String, String>] the story's metadata
    def headers
      @headers ||= begin
                     @has_read_headers = true
                     read_headers.freeze
                   end
    end

    def header?(key)
      headers.key?(key)
    end

    # @return [::Date, nil]
    def date
      ::Date.parse(self['Date']) if header?('Date')
    end

    # @return [Symbol]
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
      parse_headers(io)
    ensure
      io&.close
    end

    def parse_headers(io, head = {})
      until io.eof?
        @body_pos = io.pos
        match = HEADER_PATTERN.match(io.gets)
        break if match.nil?

        head[match[1].strip] = match[2]&.strip
      end
      massage_headers(head)
    end

    def massage_headers(head)
      if head.key?('Series')
        head['Series'] = head['Title']
        head['Title'] = head.delete('Subtitle')
      end
      head
    end

    def list(key)
      fetch(key, '').split(',').map(&:strip)
    end

    def dir_parts
      file.parent.basename.to_s.split('-')
    end
  end
end

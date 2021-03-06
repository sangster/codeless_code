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
require 'slop'

module CodelessCode
  module Filters
    # A {Composite} filter build from the arguments supplied via the CLI.
    class FromOptions < Composite
      extend Forwardable

      # @param opts [Options]
      def initialize(opts)
        @opts = opts
        @filters = nil
      end

      def lang
        @opts[:lang]&.to_sym || fallback_lang
      end

      def enabled?
        @opts.key?(:lang) || non_defaults_enabled?
      end

      def filters
        @filters ||=
          string_filters +
          integer_filters +
          [
            filter(:Date, :date),
            new_filter(:Lang, exact: lang),
            number_filter,
            translator_filter
          ]
      end

      private

      def string_filters
        %i[Credits Name Tagline Title Series].map { |name| filter(name, :str) }
      end

      def integer_filters
        %i[Geekiness].map { |name| filter(name, :int) }
      end

      def number_filter
        filter(:Number, :int) { |args| args[:exact] ||= @opts.args.last&.to_i }
      end

      def translator_filter
        new_filter(:Translator, exact: @opts[:translator_exact],
                                casecmp: @opts[:translator])
      end

      def filter(name, type, &blk)
        new_filter(name,
                   **send(:"#{type.downcase}_args", name.to_s.downcase.to_s),
                   &blk)
      end

      def new_filter(name, **args)
        yield args if block_given?
        Filters.const_get(name).new(**args)
      end

      def fallback_lang
        lang = ENV['LANG']&.split(/_|\./)&.first&.downcase&.to_sym
        Catalog.new(@opts.data_dir).languages.include?(lang) ? lang : :en
      end

      def non_defaults_enabled?
        filters.reject { |filter| filter.is_a?(Filters::Lang) }.any?(&:enabled?)
      end

      def str_args(name)
        Hash[
          %i[exact start_with end_with exclude].zip(
            @opts.slice(:"#{name}", :"#{name}_start", :"#{name}_end",
                        :"no_#{name}").values
          )
        ].tap do |args|
          args[:start_with] ||= '' if @opts[:"has_#{name}"]
        end
      end

      def int_args(name)
        Hash[
          %i[exact min max exclude].zip(
            @opts.slice(:"#{name}", :"#{name}_gte", :"#{name}_lte")
                 .values
                 .map { |num| num&.to_i }
                 .push(@opts[:"no_#{name}"])
          )
        ]
      end

      def date_args(name)
        {
          exact: @opts[:"#{name}"],
          min: @opts[:"#{name}_after"],
          max: @opts[:"#{name}_before"],
          exclude: @opts[:"no_#{name}"]
        }
      end
    end
  end
end

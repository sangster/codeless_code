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
        @filters ||= [
          Filters::Lang.new(exact: lang),

          Filters::Translator.new(exact: @opts[:translator_exact],
                                  casecmp: @opts[:translator]),

          Filters::Credits.new(**str_args(:credits)),
          Filters::Name.new(**str_args(:name)),
          Filters::Series.new(**str_args(:series)),
          Filters::Tagline.new(**str_args(:tagline)),
          Filters::Title.new(**str_args(:title)),

          Filters::Geekiness.new(**int_args(:geekiness)),
          Filters::Number.new(**int_args(:number).tap do |n|
            n[:exact] ||= @opts.args.last&.to_i
          end),

          Filters::Date.new(**date_args),
        ]
      end

      private

      def fallback_lang
        lang = ENV['LANG']&.split(/_|\./)&.first&.downcase&.to_sym
        Catalog.new(@opts.data_dir).languages.include?(lang) ? lang : :en
      end

      def non_defaults_enabled?
        filters.reject { |f| f.is_a?(Filters::Lang) }.any?(&:enabled?)
      end

      def str_args(name)
        Hash[
          %i[exact start_with end_with exclude].zip(
            @opts.slice(*%I[#{name} #{name}_start #{name}_end no_#{name}]).values
          )
        ].tap do |args|
          args[:start_with] ||= '' if @opts[:"has_#{name}"]
        end
      end

      def int_args(name)
        Hash[
          %i[exact min max exclude].zip(
            @opts.slice(*%I[#{name} #{name}_gte #{name}_lte])
                 .values
                 .map { |num| num&.to_i }
                 .push(@opts[:"no_#{name}"])
          )
        ]
      end

      def date_args
        {
          exact: date(@opts[:date]),
          min: date(@opts[:date_gte]),
          max: date(@opts[:date_lte]),
          exclude: @opts[:no_date],
        }
      end

      def date(arg)
        arg && Filters::Date::Matcher.parse(arg)
      end
    end
  end
end

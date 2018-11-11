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
require 'helper'

module Formats
  class TestFable < UnitTest
    def test_basic_html
      assert_equal 'italic text', format('<i>italic</i> text')
      assert_equal 'bold text', format('<b>bold</b> text')
      assert_equal 'link text', format('<a href="url">link</a> text')
    end

    def test_basic_html__not_across_paragraphs
      assert_equal ['not italic', 'text across paragraphs'].join("\n\n"),
                   format(['not <i>italic',
                           'text</i> across paragraphs'].join("\n\n"))
    end

    def test_custom_syntax
      assert_equal 'italic text', format('/italic/ text')
    end

    def test_custom_syntax__not_across_paragraphs
      input = ['not/italic', 'text/across paragraphs'].join("\n\n")
      assert_equal input, format(input)
    end

    def test_line_breaks
      assert_equal "line\nbreaks\n", format("line //\nbreaks //\n")
    end

    def test_remove_bad_html
      assert_equal 'bad html', format('<a>bad html</b>')
      assert_equal 'bad html', format('<a>bad html')
    end

    private

    def format(body)
      Formats::Plain.new(body).call
    end
  end
end

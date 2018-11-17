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
  class TestPlain < UnitTest
    def test_basic_html
      assert_equal 'italic text', plain('<i>italic</i> text')
      assert_equal 'bold text', plain('<b>bold</b> text')
      assert_equal 'link text', plain('<a href="url">link</a> text')
    end

    def test_basic_html__not_across_paragraphs
      assert_equal ['not italic', 'text across paragraphs'].join("\n\n"),
                   plain(['not <i>italic',
                          'text</i> across paragraphs'].join("\n\n"))
    end

    def test_custom_syntax
      assert_equal 'italic text', plain('/italic/ text')
    end

    def test_custom_syntax__not_across_paragraphs
      input = ['not/italic', 'text/across paragraphs'].join("\n\n")
      assert_equal input, plain(input)
    end

    def test_line_breaks
      assert_equal "line\nbreaks", plain("line //\nbreaks")
    end

    def test_remove_bad_html
      assert_equal 'bad html', plain('<a>bad html</b>')
      assert_equal 'bad html', plain('<a>bad html')
    end

    def test_rule
      assert_equal '- - - - - - - - -', plain('- - - - -')
    end

    def test_reference
      assert_equal '[ref]', plain('{{ref}}')
    end

    def test_header
      assert_equal "Some Header\n-----------", plain('== Some Header')
    end

    def test_quote
      assert_equal "\tQuote Lines", plain("    Quote\n    Lines")
    end

    private

    def plain(body)
      Formats::Plain.new(body).call
    end
  end
end

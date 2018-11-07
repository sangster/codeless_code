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

module Renderers
  class TestTermPage < UnitTest
    def test_title
      page = Renderers::TermPage.new
      assert_nil page.title

      page.title = 'test'
      assert_equal 'test', page.title
    end

    def test_body
      page = Renderers::TermPage.new
      assert_nil page.body

      page.body = 'test'
      assert_equal 'test', page.body
    end

    def test_headers
      page = Renderers::TermPage.new
      assert_empty page.headers

      page.add_header('Key', 'Value')
      assert_equal({ 'Key' => 'Value' }, page.headers)
    end

    def test_to_s
      page = term_page('Some Title', 'Some Body')
      assert_match(/Some Title/, page.to_s)
      assert_match(/Some Body/, page.to_s)
    end

    def test_to_s_headers
      page = term_page('Title', 'Body')
      page.add_header('My Header', 'Test 123')
      assert_match(/^My Header: Test 123$/, page.to_s)
    end

    def test_to_s_seperators
      page = term_page('Title', 'Body')
      assert_match(/^-+$/, page.to_s)
      assert_match(/^=+$/, page.to_s)
    end

    private

    def term_page(title, body, **args)
      Renderers::TermPage.new(**args).tap do |page|
        page.title = title
        page.body = body
      end
    end

    def create_fable(body = 'body', **args)
      mock_fable(<<-FABLE.strip, **args)
        Number: 123
        Title: Test Title
        Date: 2018-12-23
        Geekiness: 1
        Names: person, other
        Topics: foo, bar, baz
        Test: some text

        #{body}
      FABLE
    end
  end
end

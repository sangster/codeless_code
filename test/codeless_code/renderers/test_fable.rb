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
  class TestFable < UnitTest
    def test_delegation
      fable = create_fable(dir: 'en-test')
      renderer = Renderers::Fable.new(fable)

      keys = %i[body headers lang translator title geekiness names topics]
      keys.each do |key|
        assert_equal fable.send(key), renderer.send(key)
      end
    end

    def test_for_pager
      renderer = Renderers::Fable.new(create_fable('body'))

      page = renderer.for_pager(Formats::Raw)
      assert_kind_of Renderers::TermPage, page

      assert_equal renderer.title, page.title
      assert_equal 'body', page.body
    end

    def test_for_pager_headers
      renderer = Renderers::Fable.new(create_fable('body'))
      page = renderer.for_pager(Formats::Raw)

      assert_equal %w[Number Date Geekiness Names Topics Test],
                   page.headers.keys
      refute_includes page.headers.keys, 'Title'
    end

    def test_for_pager_fallback_format
      renderer = Renderers::Fable.new(create_fable('<p>body</p>'))

      assert_output(nil, /Error parsing.*format error!/) do
        page = renderer.for_pager(failure_format, fallback: Formats::Raw)
        assert_equal '<p>body</p>', page.body
      end
    end

    def test_for_list
      renderer = Renderers::Fable.new(create_fable)
      assert_equal '00123  Test Title', renderer.for_list
    end

    def test_for_list_with_headers
      renderer = Renderers::Fable.new(create_fable)
      assert_equal '00123  Test Title    Number: "123", Date: "2018-12-23"',
                   renderer.for_list(%w[Number Date])
    end

    def test_for_list__title_width
      renderer = Renderers::Fable.new(create_fable)
      assert_equal '00123       Test Title', renderer.for_list(title_width: 15)
    end

    private

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

    def failure_format
      proc { raise 'format error!' }.tap do |format|
        format.define_singleton_method(:new) { |_| self }
      end
    end
  end
end

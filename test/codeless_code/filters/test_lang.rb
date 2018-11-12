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

module Filters
  class TestLang < UnitTest
    def test_enabled
      refute_predicate Filters::Lang.new, :enabled?

      assert_predicate filter(exact: :en), :enabled?
    end

    def test_call
      fable = create_fable(dir: 'en-test')
      assert filter(exact: :en).call(fable),
             'expected lang to match directory name'
      refute filter(exact: :fr).call(fable),
             'expected lang to not match other language'
    end

    private

    def filter(exact:)
      Filters::Lang.new(exact: exact)
    end

    def create_fable(body = 'body', **args)
      mock_fable(<<-FABLE.strip, **args)
        Number: 123

        #{body}
      FABLE
    end
  end
end

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
  class TestTranslator < UnitTest
    def test_enabled
      refute_predicate Filters::Translator.new, :enabled?

      assert_predicate filter(exact: 'test', casecmp: nil), :enabled?
      assert_predicate filter(exact: nil, casecmp: 'test'), :enabled?
    end

    def test_call_exact
      fable = create_fable(dir: 'en-Test')
      assert filter(exact: 'Test', casecmp: nil).call(fable),
             'expected translator to match directory name'
      refute filter(exact: 'test', casecmp: nil).call(fable),
             'expected lang to not match other language'
    end

    private

    def filter(exact:, casecmp:)
      Filters::Translator.new(exact: exact, casecmp: casecmp)
    end

    def create_fable(body = 'body', **args)
      mock_fable(<<-FABLE.strip, **args)
        Number: 123

        #{body}
      FABLE
    end
  end
end

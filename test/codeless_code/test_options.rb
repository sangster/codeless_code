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

class TestOptions < UnitTest
  def test_opts
    assert_kind_of Slop::Result, options.opts
  end

  def test_opts_does_not_accept_bad_options
    assert_raises { options('--unknown-argument').opts }
  end

  def test_args
    assert_empty options.args
    assert_empty options('--daily').args
    assert_equal ['123'], options('-D', '2015', '123').args
  end

  def test_args_too_many
    assert_raises { options('first', 'second').opts }
  end

  def test_help
    assert_kind_of String, options.help
  end

  def test_help_accepts_bad_options
    options('--unknown-argument').help
    pass 'did not raise'
  end

  def test_key?
    assert options('--help').key?(:help), '--help should supply :help key'
    assert options('-h').key?(:help),     '-h should supply :help key'
  end

  def test_data
    assert_equal Pathname.new('/foo'), options('-p', '/foo').data_dir
  end

  private

  def options(*args)
    (@options ||= {})[args] ||= Options.new('codeless_code', args)
  end
end

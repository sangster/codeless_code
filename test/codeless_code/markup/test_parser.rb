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

module Markup
  class TestParser < UnitTest # rubocop:disable Metrics/ClassLength
    def test_name_is_main
      assert_equal 'main', parse.name
    end

    def test_anchor
      para = parse('[[label]]').child

      assert_equal 'p', para.name
      assert_equal 'a', para.child.name
      assert_equal 'label', para.child.content
    end

    def test_link
      link = parse('[[url|label]]').child.child

      assert_equal 'a', link.name
      assert_equal 'label', link.content
      assert_equal 'url', link['href']
    end

    def test_italic
      para = parse('/italic/').child

      assert_equal 'p', para.name
      assert_equal 'em', para.child.name
      assert_equal 'italic', para.child.content
    end

    def test_sup
      para = parse('{{ref}}').child

      assert_equal 'p', para.name
      assert_equal 'sup', para.child.name
      assert_equal 'ref', para.child.content
    end

    def test_hr
      rule = parse('- - - -').child

      assert_equal 'hr', rule.name
    end

    def test_br
      para = parse("first //\nsecond").child

      assert_equal 'p', para.name
      children = para.children
      assert_equal 'first', children[0].content
      assert_equal 'br', children[1].name
      assert_equal 'second', children[2].content
    end

    def test_quote
      quote = parse("    Quote\n    Lines").child

      assert_equal 'blockquote', quote.name
      assert_equal 'Quote Lines', quote.content
    end

    private

    def parse(body = nil)
      Markup::Parser.new(body || fable.body).call
    end

    def fable(dir = 'en-test', fable = 'case-123.txt', root: fake_fs)
      (@fable ||= {})["#{dir}/#{fable}"] ||=
        Fable.new(root.glob(dir).first.glob(fable).first)
    end

    def fake_fs
      FakeDir.new('/').tap do |fs|
        fs.create_path('en-test/case-123.txt', fable_text)
      end
    end

    def fable_text
      <<-FABLE.gsub(/^ {8}/, '')
        Date: 2013-12-28
        Number: 125
        Geekiness: 0
        Title: Power
        Names: Subashikoi, Shinpuru, Spider Clan
        Topics: power, promotion, management, work-life balance
        Illus.0.src: Vine.jpg
        Illus.0.title: Even a garden needs a little debugging now and then.

        It is the function of the Temple abbots to direct the
        activities of their respective clans: choosing projects,
        setting deadlines, apportioning tasks, and employing
        whatever means are necessary to ensure that schedules are
        met.  It is for these powers that the abbots are both envied
        and despised.  Indeed, it is rare for abbot and monk to
        cross paths without the latter finding himself more
        miserable for the experience.

        Thus it was with no great joy that the elder monk
        [[Shinpuru]] found himself visited by the new head abbot of
        the [[Spider Clan]].

        - - -

        Shinpuru was in the temple greenhouse, tending the plants of
        a small winter garden that he kept as a hobby, when the
        head abbot approached and bowed low, saying: "Have I the good
        fortune of being in the presence of the monk Shinpuru, whose
        code is admired throughout the Temple?"

        "This miserable soul is he," said Shinpuru, returning the bow.

        "I have come to ask if you have given any thought to the
        future," said the abbot.

        "Tomorrow I expect the sun shall rise," answered Shinpuru.
        "Unless I am wrong, in which case it will not."

        "I was thinking of your future, specifically," replied the
        abbot.

        The head abbot frowned.  "What would Shinpuru think of a
        seed that refused to sprout, or a tree that refused to yield
        fruit?  What else should I think of a monk who so quickly
        declines an opportunity for growth, for command, for power?"

        Shinpuru set aside his shears to tie up the vine.  "Define
        power," he said.

        "The ability to do as one wishes," said the abbot.

        "Well, then," said Shinpuru.  "Tomorrow I wish to greet the
        sunrise with my little bowl.  Then I wish to take some hot
        tea at my workstation as I read the technical sites I find
        most illuminating, after which I look forward to a fruitful
        day of coding interrupted only by some pleasant exchanges
        with my fellows and a midday meal at this very spot, tending
        my garden.  When night falls I wish to find myself in my
        cozy room with a belly full of rice, a cup full of hot sake,
        a purse full of coins sufficient to buy more seeds, and a
        mind empty of all other cares."

        The abbot bowed.  "I expect that Shinpuru has all the power
        he could desire, then.  Unless he is wrong."

        "I am seldom wrong about such things," said Shinpuru,
        picking up his shears again as another yellow leaf caught
        his eye.  "In a world where even the sunrise is uncertain, a
        man may be excused for not knowing a great many things.  But
        to not know my own heart?  I hope to never be so hopeless
        a fool."


        {{*}} As documented in cases [[#61|61]], [[#62|62]], [[#67|67]], [[#120|120]], and probably others besides.  Abbots in the Spider Clan have the average life expectancy of a dolphin in the Gobi desert.
      FABLE
    end
  end
end

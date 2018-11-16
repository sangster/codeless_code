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
  class TestParser < UnitTest
    def test_something
      par = parser
      nodes = Markup::Nodes.convert_html(par.parsed_paragraphs)
    end

    private

    def parser
      Markup::Parser.new(fable.body)
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

        "If the sun does not rise, my future will be the least of my
        concerns," said Shinpuru.  "If it does rise, then I expect
        to greet it while enjoying a small bowl of rice and eel.
        Unless I am wrong, in which case I will not."

        The abbot smiled.  "It is true then, that the monk Shinpuru
        plans for all contingencies.  This is also why I have come.
        Of late there has been a shortage of abbots in the
        Spider Clan.{{*}}  The Temple wishes to bestow upon you
        the honor of promotion into our ranks."

        "I am humbled," said Shinpuru, bowing again.

        "The work is difficult," continued the abbot.  "Our day
        begins well before sunrise, which you would seldom be able
        to greet at your leisure, for there are many meetings to
        attend and we run with our bowls from one to another.
        Likewise you will not often see the sunset, except perhaps
        on a webcam.  In exchange for this you will receive far
        greater compensation from the Temple coffers, and the power
        to direct the activities of the Temple itself."

        "And what will become of 'Shinpuru, whose code is admired
        throughout the Temple,' when he no longer codes?"
        asked the monk.

        "Fear not!" said the abbot. "You will do what you have
        excelled at, only one level higher: Meta-Coding, if you
        will.  Instead of design documents we produce long-term
        plans; instead of software we churn out schedules; instead
        of defects and features we speak of costs and benefits.  The
        Temple itself is the machine we practice our arts upon,
        refactoring it as we see fit."

        "A most worthy cause," said Shinpuru, returning his
        attention to his vines.  "I, too, have noticed the shortage
        of abbots.  Such is the price of power.  For as the
        seafaring matriarch [[Subashikoi]] once observed, the monks
        may command the rigging and the masters may command the
        monks, but it is the abbots who chart the course and hold
        the tiller; so it is the abbots who are consigned to the
        deep when the ship founders -- oftimes by their own crew."

        "Only fools meet such a fate," said the abbot.  "And the
        monk Shinpuru is no fool.  Unless /I/ am wrong, but I am
        seldom wrong about such things."

        "Then you will not think me a fool for declining the
        Temple's generous offer," said Shinpuru, pruning a few
        yellow leaves.

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

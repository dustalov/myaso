# encoding: utf-8

class MiniTest::Unit::TestCase
  def populate_tokyo_cabinet! myaso
    # prefixes
    Myaso::Fixtures::PREFIXES.each do |id, prefix|
      myaso.prefixes.set id, prefix
    end

    # rules
    Myaso::Fixtures::RULES.each do |id, rule|
      myaso.rules.set id, rule
    end

    # stems
    Myaso::Fixtures::STEMS.each do |id, stem|
      myaso.stems.set id, stem
    end

    # words
    Myaso::Fixtures::WORDS.each do |id, word|
      myaso.words.set id, word
    end
  end
end

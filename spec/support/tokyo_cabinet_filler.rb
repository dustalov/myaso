# encoding: utf-8

class MiniTest::Unit::TestCase
  def populate_tokyo_cabinet! myaso
    # prefixes
    Myaso::Fixtures::PREFIXES.each do |id, prefix|
      values = prefix.values_at('prefix')
      myaso.prefixes.set(Myaso::Prefix.new(id, *values))
    end

    # rules
    Myaso::Fixtures::RULES.each do |id, rule|
      values = rule.values_at('rule_set_id', 'msd', 'prefix', 'suffix')
      myaso.rules.set(Myaso::Rule.new(id, *values))
    end

    # stems
    Myaso::Fixtures::STEMS.each do |id, stem|
      values = stem.values_at('rule_set_id', 'msd', 'stem')
      myaso.stems.set(Myaso::Stem.new(id, *values))
    end

    # words
    Myaso::Fixtures::WORDS.each do |id, word|
      values = word.values_at('stem_id', 'rule_id')
      myaso.words.set(Myaso::Word.new(id, *values))
    end
  end
end

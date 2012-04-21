# encoding: utf-8

require 'unicode_utils/downcase'

class Myaso::Analyzer
  Result = Struct.new(:word_id, :stem, :rule, :msd)

  attr_reader :myaso, :language

  def initialize myaso, language
    @myaso, @language = myaso, language
  end

  def analyze word
    return [] unless word
    word = normalize(word)

    # retrieve the possible suffixes of the word
    suffixes = possible_suffixes(word)

    # collect the possible stem/suffix splits
    splits = suffixes.map do |suffix|
      stems = possible_stems(word, suffix)
      unless stems.empty?
        stems.map do |stem_id|
          [stem_id, suffix]
        end
      else
        [[nil, suffix]]
      end
    end.flatten(1).map do |stem_id, suffix|
      rule_set_id = if stem_id
        stem = myaso.stems.find(stem_id)
        stem['rule_set_id']
      end
      rules_ids = myaso.rules.select_by_suffix(suffix, rule_set_id)
      [stem_id, rules_ids]
    end

    # word candidates
    result = []

    # dictionary word check
    splits.each do |stem_id, rules_ids|
      next unless stem_id

      rules_ids.each do |rule_id|
        word_id = myaso.words.find_by_stem_id_and_rule_id(stem_id, rule_id)
        next unless word_id

        # # we need to merge the stem and rule MSDs
        rule = myaso.rules.find(rule_id)
        rule['id'] = rule_id

        stem = myaso.stems.find(stem_id)
        stem['id'] = stem_id

        msd = Myaso::MSD.new(language, rule['msd'])
        if stem['msd']
          msd.merge! Myaso::MSD.new(language, stem['msd']).grammemes
        end

        result << Result.new(word_id, stem, rule, msd)
      end
    end

    result
  end

  protected
    # Normalize +word+: strip unnecessary left and right characters
    # and downcase it.
    #
    def normalize(word)
      UnicodeUtils.downcase(word.strip)
    end

    # Cuts a stem of the given +word+ with specified +suffix+.
    # This method cares only about the lengths and not about
    # contents.
    #
    #   cut_stem('abc', 'c') # => 'ab'
    #
    def cut_stem(word, suffix)
      stem_length = word.length - suffix.length
      word[0...stem_length]
    end

    # List of the possible suffixes of the +word+, which is ordered
    # by decreasing of the suffix length.
    #
    def possible_suffixes(word)
      return [] unless word && !word.empty?

      # empty suffix is a suffix, too
      suffixes = ['']

      word.length.times do |i|
        break unless slice = word[-i..-1].to_s
        if myaso.rules.has_suffix? slice
          suffixes.unshift(slice)
        end
      end

      suffixes
    end

    # List of the possible stems of the +word+.
    #
    def possible_stems(word, suffix)
      myaso.stems.select cut_stem(word, suffix)
    end
end

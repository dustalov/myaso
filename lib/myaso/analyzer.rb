# encoding: utf-8

require 'unicode_utils/downcase'

# The Analyzer performs the morphological analysis and lemmatization
# functions.
#
class Myaso::Analyzer
  # A structure of analysis result.
  #
  Result = Struct.new(:word_id, :stem, :rule, :msd)

  attr_reader :myaso, :language

  # Create a new Analyzer instance.
  #
  # Analyzer should be initialized before use. It requires two
  # things: a prepared Myaso::Client and preferred language to
  # work on.
  #
  # ```ruby
  # # prepare the Tokyo Cabinet client
  # myaso = Myaso::TokyoCabinet.new('path/to/lexicon')
  #
  # # load the Russian morphosyntactic descriptions
  # require 'myaso/msd/russian'
  #
  # # initialize the analyzer
  # analyzer = Myaso::Analyzer.new(myaso, Myaso::MSD::Russian)
  # ```
  #
  # After these steps Analyzer may be used to perform its duties.
  #
  # @param myaso [Myaso::Client] a client.
  # @param language [Myaso::MSD::Language] a language to operate on.
  #
  def initialize myaso, language
    @myaso, @language = myaso, language
  end

  # Analyze the single word.
  #
  # ```ruby
  # pp analyzer.lookup 'бублик'
  # ```
  #
  # The analysis results for word *бублик* are looking like this:
  #
  # ```
  # [#<struct Myaso::Analyzer::Result
  #   word_id="410728",
  #   stem={"rule_set_id"=>"21", "stem"=>"бублик", "msd_id"=>"687", "id"=>"18572"},
  #   rule={"msd"=>"Ncmsn", "rule_set_id"=>"21", "id"=>"502"},
  #   msd=
  #    #<Myaso::MSD:0x2b04e68 language=Myaso::MSD::Russian pos=:noun grammemes={:type=>:common, :gender=>:masculine, :number=>:singular, :case=>:nominative, :animate=>:no}>>,
  #  #<struct Myaso::Analyzer::Result
  #   word_id="410731",
  #   stem={"rule_set_id"=>"21", "stem"=>"бублик", "msd_id"=>"687", "id"=>"18572"},
  #   rule={"msd"=>"Ncmsa", "rule_set_id"=>"21", "id"=>"505"},
  #   msd=
  #    #<Myaso::MSD:0x2b03608 language=Myaso::MSD::Russian pos=:noun grammemes={:type=>:common, :gender=>:masculine, :number=>:singular, :case=>:accusative, :animate=>:no}>>]
  # ```
  #
  # @param word [String] a word to be analyzed.
  # @return [Array<Result>] an array of analysis results.
  #
  def lookup word
    return [] unless word
    word = normalize(word)

    # retrieve the possible suffixes of the word
    suffixes = possible_suffixes(word)

    # collect the possible stem/suffix splits
    splits = suffixes.map do |suffix|
      stems = possible_stems(word, suffix)

      unless stems.empty?
        stems.map { |stem_id| [stem_id, suffix] }
      else
        [[nil, suffix]]
      end
    end.flatten(1).map do |stem_id, suffix|
      rule_set_id = if stem_id
        stem = myaso.stems.find(stem_id)
        stem.rule_set_id
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

        # we need to merge the stem and rule MSDs
        rule = myaso.rules.find(rule_id)
        stem = myaso.stems.find(stem_id)
        msd = Myaso::MSD.new(language, rule.msd)

        if stem.msd
          msd.merge! Myaso::MSD.new(language, stem.msd).grammemes
        end

        result << Result.new(word_id, stem, rule, msd)
      end
    end

    result
  end

  # Perform the word lemmatization based on its `stem_id`.
  #
  # Lemmatization is the process of grouping together the different
  # inflected forms of a word so they can be analysed as a single item.
  #
  # This can be done in the following way:
  #
  # ```ruby
  # # take the first Myaso::Result of analysis
  # result = analyzer.lookup('люди').first
  #
  # # lemmatize
  # analyzer.lemmatize(result.stem['id']) # => человек
  # ```
  #
  # @param stem_id [Fixnum] a stem identifier.
  # @return [String] a lemma for the given stem.
  #
  def lemmatize stem_id
    stem = myaso.stems.find(stem_id)

    rules = myaso.rules.
      select_by_rule_set_id(stem.rule_set_id).
      map { |id| [id, myaso.rules.find(id)] }

    rule_id = rules.sort do |(id1, rule1), (id2, rule2)|
      msd1, msd2 = Myaso::MSD.new(language, rule1.msd),
                   Myaso::MSD.new(language, rule2.msd)

      length_criteria = msd1.grammemes.length <=> msd2.grammemes.length
      next length_criteria unless length_criteria == 0

      positions_cost(msd1) <=> positions_cost(msd2)
    end.first[0]

    word_id = myaso.words.find_by_stem_id_and_rule_id(stem_id, rule_id)
    myaso.words.assemble(word_id)
  end

  # Perform the word inflection based on its `stem_id` and MSD.
  #
  # Lemmatization is the modification of a word to express different
  # grammatical categories such as tense, grammatical mood,
  # grammatical voice, aspect, person, number, gender and case.
  #
  # This can be done in the following way:
  #
  # ```ruby
  # # take the first Myaso::Result of analysis
  # result = analyzer.lookup('человек').first
  #
  # # inflect
  # analyzer.inflect(result.stem['id'], 'Nc-pn') # => люди
  # ```
  #
  # @param stem_id [Fixnum] a stem identifier.
  # @param msd_string [String] a textual MSD representation.
  # @return [String] an inflection for the given stem and required MSD.
  #
  def inflect stem_id, msd_string
    stem = myaso.stems.find(stem_id)
    msd = Myaso::MSD.new(language, msd_string)

    rules = myaso.rules.
      select_by_rule_set_id(stem.rule_set_id).
      map { |id| [id, myaso.rules.find(id)] }

    rule_id = rules.sort do |(id1, rule1), (id2, rule2)|
      msd1, msd2 = Myaso::MSD.new(language, rule1.msd),
                   Myaso::MSD.new(language, rule2.msd)

      msd_similarity(msd, msd1) <=> msd_similarity(msd, msd2)
    end.last[0]

    if word_id = myaso.words.find_by_stem_id_and_rule_id(stem_id, rule_id)
      myaso.words.assemble(word_id)
    else
      myaso.words.assemble_stem_rule(stem_id, rule_id)
    end
  end

  protected
    # Normalize `word`: strip unnecessary left and right characters
    # and downcase it.
    #
    # @param word [String] a word.
    # @return [String] a normalized word.
    #
    def normalize(word)
      UnicodeUtils.downcase(word.strip)
    end

    # Cuts a stem of the given `word` with specified `suffix`.
    # This method cares only about the lengths and not about
    # contents.
    #
    # ```ruby
    # cut_stem('abc', 'c') # => 'ab'
    # ```
    #
    # @param word [String] a word.
    # @param suffix [String] a suffix of this word.
    # @return [String] a word without suffix.
    #
    def cut_stem(word, suffix)
      stem_length = word.length - suffix.length
      word[0...stem_length]
    end

    # List of the possible suffixes of the `word`, which is ordered
    # by decreasing of the suffix length.
    #
    # @param word [String] a word.
    # @return [Array<String>] a list of the possible suffixes of
    #   the word.
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

    # List of the possible stems of the `word`.
    #
    # @param word [String] a word.
    # @param suffix [String] a suffix of this word.
    # @return [Array<String>] a list of the possible stems of
    #   this word.
    #
    def possible_stems(word, suffix)
      myaso.stems.select cut_stem(word, suffix)
    end

    # Compute the MSD positions cost for lemmatization purposes.
    #
    # @param msd [Myaso::MSD] a MSD instance.
    # @return a positions cost of this MSD.
    #
    def positions_cost(msd)
      msd.grammemes.inject(0) do |cost, (k, v)|
        attributes = language::CATEGORIES[msd.pos][:attrs]
        attribute = attributes.find { |a| a.first == k }

        cost + attribute.last.keys.index { |a| a == v }
      end
    end

    # Compute the MSD similarity value.
    #
    # @param origin [Myaso::MSD] a MSD sample to be considered.
    # @param msd [Myaso::MSD] a MSD instance.
    # @return a MSD similarity value.
    #
    def msd_similarity(origin, msd)
      intersection = if origin.pos == msd.pos
        origin.grammemes.inject(0) do |sim, (k, v)|
          msd[k] == v ? sim + 1 : sim
        end
      else
        0
      end

      union = (origin.grammemes.keys | msd.grammemes.keys).length

      intersection - union
    end
end

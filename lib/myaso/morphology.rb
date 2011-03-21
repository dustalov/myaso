# encoding: utf-8

# Morphology Parser of Myaso.
#
class Myaso::Morphology
  include TokyoCabinet

  attr_reader :store, :stem_trie, :suffix_trie
  private :store, :stem_trie, :suffix_trie

  # Create a new instance of the Myaso::Morphology analyzer.
  #
  # ==== Parameters
  # store<Myaso::Store>:: Initialized Myaso store.
  #
  def initialize(store)
    @store = store
    @stem_trie = Myaso::Store::Trie.new(store.stems)
    @suffix_trie = Myaso::Store::Trie.new(store.suffixes)
  end

  # Perform a word morphology information prediction.
  #
  # ==== Parameters
  # word<String>:: Word to analyze.
  #
  # ==== Returns
  # Array:: List of Myaso::Model::Gram, which probably can represent an
  # actual word morphology.
  #
  def predict(word)
    word = drop_prefixes(make_suitable(word))
    suffixes = possible_suffixes(word)

    splits = suffixes.map do |suffix|
      [ possible_stem(word, suffix), suffix ]
    end.delete_if do |stem_id, suffix|
      !stem_id
    end.map do |stem_id, suffix|
      [ stem_id, suffix_trie.find(suffix) ]
    end

    known = splits.map do |stem_id, suffix_id|
      stem_forms = rule_forms_by_stem(stem_id)
      suffix_forms = rule_forms_by_suffix(suffix_id)
      stem_forms & suffix_forms
    end.flatten

    known.map do |rule_form_id|
      store.rule_forms[rule_form_id].tap do |rule_form|
        pattern_id = rule_form['pattern_id'].force_encoding('utf-8')
        store.patterns[pattern_id].tap do |pattern|
          pattern['grammemes'].force_encoding('utf-8')
          pattern['grammemes'] = pattern['grammemes'].split(',')
          pattern['pos'].force_encoding('utf-8')
          rule_form['pattern'] = pattern
        end
      end
    end
  end

  private
    def make_suitable(word)
      word.strip.mb_chars.upcase.to_s
    end

    def drop_prefixes(word)
      clean_word = word.dup

      store.prefixes.each do |key|
        record = store.prefixes[key]
        prefix = record['prefix'].strip.force_encoding('utf-8')
        if clean_word.start_with? prefix
          clean_word = clean_word[prefix.length..-1]
        end
      end

      clean_word == word ? word : clean_word
    end

    def possible_suffixes(normal_word)
      return [] if !normal_word || normal_word.empty?
      word = normal_word.reverse

      endings = []
      word.length.times do |i|
        slice = word[0..i]
        break unless slice
        endings.unshift(slice) if suffix_trie.find(slice)
      end

      endings << ''
      endings
    end

    def possible_stem(normal_word, suffix)
      word_length = normal_word.length - suffix.length - 1
      word = normal_word[0..word_length].reverse
      stem_trie.find(word)
    end

    def rule_forms_by_suffix(suffix_id)
      if suffix_id
        suffix = store.suffixes[suffix_id]
        return [] unless suffix
      end

      rule_forms = []

      query(store.rule_forms, proc { |query|
        if suffix_id
          query.addcond('suffix_id', TDBQRY::QCSTREQ, suffix_id)
        else
          query.addcond('suffix_id', TDBQRY::QCSTRRX |
            TDBQRY::QCNEGATE, '^(.+)$')
        end
      }) { |found_id| rule_forms << found_id }

      rule_forms
    end

    def rule_forms_by_stem(stem_id)
      stem = store.stems[stem_id]
      return [] unless stem

      rule_id = stem['rule_id']
      return [] unless store.rules[rule_id]

      rule_forms = []

      query(store.rule_forms, proc { |query|
        query.addcond('rule_id', TDBQRY::QCSTREQ, rule_id)
      }) { |found_id| rule_forms << found_id }

      rule_forms
    end

    def query(store, query_setup, &block)
      TokyoCabinet::TDBQRY.new(store).
        tap(&query_setup).
        search.each(&block)
    end
end

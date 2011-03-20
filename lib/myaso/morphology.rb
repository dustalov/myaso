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
    word = make_suitable('кот') #(word)

    tuple = possible_suffixes(word).map do |suffix|
      [ possible_stem(word, suffix),
        suffix_trie.find(suffix) ]
    end.last

    stem_id, suffix_id = tuple
    p stem_trie.retrieve(stem_id)
    #p suffix_trie.retrieve(suffix_id)

    rule_forms_by_stem(stem_id).each do |rule_form_id|
      rule_form = store.rule_forms[rule_form_id]
      ancode = rule_form['ancode'].force_encoding('utf-8').strip
      p store.patterns[ancode]['grammemes'].force_encoding('utf-8')
#      p store.patterns[]
    end

#.reduce([]) do |r, (stem_id, suffix_id)|
#      stem_forms = rule_forms_by_stem(stem_id)
#      suffix_forms = rule_forms_by_suffix(suffix_id)
#      r << (stem_forms & suffix_forms)
#    end.delete_if do |stem_id, suffix_id|
      #!stem_id
      #    end
    nil
  end

  private
    def make_suitable(word)
      word.strip.mb_chars.upcase.to_s
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
          query.addcond('suffix_id', TDBQRY::QCNUMEQ, suffix_id)
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
        query.addcond('rule_id', TDBQRY::QCNUMEQ, rule_id)
      }) { |found_id| rule_forms << found_id }

      rule_forms
    end

    def query(store, query_setup, &block)
      TokyoCabinet::TDBQRY.new(store).
        tap(&query_setup).
        search.each(&block)
    end
end

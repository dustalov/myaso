# encoding: utf-8

# Morphology Parser of Myaso.
#
class Myaso::Morphology
  attr_reader :store
  private :store

  # Create a new instance of the Myaso::Morphology analyzer.
  #
  # ==== Parameters
  # store<Myaso::Store>:: Initialized Myaso store.
  #
  def initialize(store)
    @store = store
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
    gram = predict_by_lemma(word)

    if gram.empty?
      gram = predict_by_suffix(word)
    end

    gram.sort do |g1, g2|
      store.flexias[g1.flexia_id].freq <=>
        store.flexias[g1.flexia_id].freq
    end.reverse
  end

  private
    def predict_by_lemma(word) # :nodoc:
      gram = []

      store.prefixes['prefixes'].each do |prefix|
        if word.mb_chars.upcase.start_with? prefix
          word = word[prefix.size..-1]
        end
      end

      word.mb_chars.size.downto 1 do |i|
        word_begin = word.mb_chars[0..i - 1].upcase.to_s
        if lemma = store.lemmas[word_begin]
          word_end = word.mb_chars[i + 1..-1].upcase.to_s

          flexia_id = lemma.flexia_id
          flexia = store.flexias[flexia_id]

          flexia.forms.each do |form|
            suffix, ancode = form.suffix, form.ancode
            next unless suffix == word_end

            graminfo = store.ancodes[ancode]

            normal = word_begin + flexia.forms[0].suffix
            method_call = "#{__method__}('#{word.mb_chars.upcase}')"
            grammems = graminfo.grammems.split(',')

            gram << Myaso::Model::Gram.new(normal, graminfo.part,
              grammems, flexia_id, ancode, word_begin, method_call)
          end

          return gram
        end
      end

      []
    end

    def predict_by_suffix(word) # :nodoc:
      gram = []

      5.downto 1 do |i|
        word_end_mb = word.mb_chars[-i..-1]
        next unless word_end_mb

        word_end = word_end_mb.upcase.to_s

        if store.endings.key?(word_end)
          ending = store.endings[word_end]

          ending.paradigms.each do |flexia_id, forms|
            flexia = store.flexias[flexia_id]

            forms.each do |id|
              form = flexia.forms[id]
              suffix, ancode = form.suffix, form.ancode
              graminfo = store.ancodes[ancode]

              if Myaso::Constants::PRODUCTIVE_CLASSES.include? graminfo.part
                suffix_offset = suffix.mb_chars.size + 1
                lemma = word.mb_chars[0..-suffix_offset].upcase.to_s
                normal = lemma + flexia.forms[0].suffix
                method_call = "#{__method__}('#{word_end}')"
                grammems = graminfo.grammems.split(',')

                gram << Myaso::Model::Gram.new(normal, graminfo.part,
                  grammems, flexia_id, ancode, lemma, method_call)
              end
            end
          end
        end

        break unless gram.empty?
      end

      gram
    end
end

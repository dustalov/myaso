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
    # TODO: more prediction methods
    predict_by_suffix(word)
  end

  private
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
              suffix_offset = suffix.size + 1
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

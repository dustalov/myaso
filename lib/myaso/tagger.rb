# encoding: utf-8

# This class is an implementation of the Viterbi algorithm.
#
class Myaso::Tagger
  attr_reader :model

  # An instance of Tagger should be initialized with an instance of
  # trained HMM.
  #
  def initialize(model)
    @model = model
  end

  # Viterbi algorithm itself. Return tags that input sentence
  # should be annotated.
  #
  def annotate(sentence)
    return [] if sentence.size == 0

    tags_first = [model.start_symbol]

    pi_table, bp_table = Myaso::PiTable.new, Myaso::PiTable.new
    pi_table[1, model.start_symbol, model.start_symbol] = 0.0

    sentence = sentence.map { |w| model.classify(w) }
    sentence.unshift(model.start_symbol, model.start_symbol)

    sentence.each_with_index.each_cons(3) do |(w1, i1), (w2, i2), (word, index)|
      w_tags = (i1 < 2) ? tags_first : model.lexicon.tags(w1)
      u_tags = (i2 < 2) ? tags_first : model.lexicon.tags(w2)
      v_tags = model.lexicon.tags(word)

      u_tags.product(v_tags).each do |u, v|
        pi_value, bp_value = w_tags.map do |w|
          next [-Float::INFINITY, w] unless pi_table[index - 1, w, u].finite?
          [pi_table[index - 1, w, u] + Math.log2(model.q(w, u, v) * model.e(word, v)), w]
        end.max_by { |pi, _| pi }

        pi_table[index, u, v], bp_table[index, u, v] = pi_value, bp_value
      end
    end

    y = []
    size = sentence.size - 1
    if size.zero?
      v_tags = tags(sentence[-1])
      return tags_first.product(v_tags).
        max_by { |u, v| pi_table[size, u, v] + Math.log2(model.q(u, v, model.stop_symbol)) }.last
    end

    u_tags, v_tags = model.lexicon.tags(sentence[-2]), model.lexicon.tags(sentence[-1])
    y[size - 1], y[size] = u_tags.product(v_tags).
      max_by { |u, v| pi_table[size, u, v] + Math.log2(model.q(u, v, model.stop_symbol)) }

    size.downto(4) do |index|
      y[index - 2] = bp_table[index, y[index - 1], y[index]]
    end

    y[2..-1]
  end
end

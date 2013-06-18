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
    sentence = sentence.map { |w| model.classify(w) }
    sentence.unshift(model.start_symbol, model.start_symbol)
    backward(sentence, *forward(sentence))
  end

  protected
  # Emit probabilities into the dynamic programming tables.
  #
  def forward(sentence)
    pi, bp = Myaso::PiTable.new, Myaso::PiTable.new
    pi[1, model.start_symbol, model.start_symbol] = 0.0

    sentence.each_with_index.each_cons(3) do |(w1, i1), (w2, i2), (word, k)|
      w_tags = (i1 < 2) ? [model.start_symbol] : model.lexicon.tags(w1)
      u_tags = (i2 < 2) ? [model.start_symbol] : model.lexicon.tags(w2)
      v_tags = model.lexicon.tags(word)

      u_tags.product(v_tags).each do |u, v|
        pi[k, u, v], bp[k, u, v] = forward_iteration(pi, k, u, v, w_tags, word)
      end
    end

    [pi, bp]
  end

  # Essential of forward part of Viterbi algorithm.
  #
  def forward_iteration(pi, k, u, v, tags, word)
    tags.select { |w| (value = pi[k - 1, w, u]) && value.finite? }.
      map! { |w| [pi[k - 1, w, u] + probability(w, u, v, word), w] }.
      max_by(&:first)
  end

  # Use backpoints to retrieve the computed tags from the previous stage.
  #
  def backward(sentence, pi, bp)
    size = sentence.size - 1

    if (size - 2).zero?
      return model.lexicon.tags(sentence[-1]).map { |v| [v] }.
        max_by { |v| pi[size, model.start_symbol, *v] +
                     probability(model.start_symbol, *v, model.stop_symbol) }
    end

    tags = prepare_backward(sentence, pi)

    size.downto(4) do |k|
      tags[k - 2] = bp[k, tags[k - 1], tags[k]]
    end

    tags.slice! 2..-1
  end

  # Preparations to tags computing.
  #
  def prepare_backward(sentence, pi)
    size = sentence.size - 1
    tags = Array.new(sentence.size)

    u_tags, v_tags = model.lexicon.tags(sentence[-2]), model.lexicon.tags(sentence[-1])

    tags[size - 1], tags[size] = u_tags.product(v_tags).
      select { |u, v| (value = pi[size, u, v]) && value.finite? }.
      max_by { |u, v| pi[size, u, v] + probability(u, v, model.stop_symbol) }

    tags
  end

  # Compute the probability of q(v|w, u) * e(word|v).
  #
  def probability(w, u, v, word = nil)
    return Math.log2(model.q(w, u, v)) unless word
    Math.log2(model.q(w, u, v) * model.e(word, v))
  end
end

# encoding: utf-8

# Any HMM tagger requires a trained model that can perform such tasks as
# producing smoothed q() and e() values, replace unknown words with special
# symbols.
#
class Myaso::Tagger::Model
  attr_reader :ngrams, :lexicon, :interpolations

  # Tagging model requires n-grams and lexicon.
  #
  def initialize
    @ngrams, @lexicon = Myaso::Ngrams.new, Myaso::Lexicon.new
    learn!
  end

  # Linear interpolation model of processing probability of
  # occurence of the trigram (first, second, third). It
  # consider three summands: the first one has the next sense:
  # probability that current tag is (third) if last two are
  # (first, second), the second one -- that last one is (second),
  # and the last summand consider independent probability that
  # current tag is (third).
  #
  def q(first, second, third)
    q1 = if (q1_denominator = ngrams.unigrams_count).zero?
      0
    else
      ngrams[third] / q1_denominator.to_f
    end

    q2 = if (q2_denominator = ngrams[second]).zero?
      0
    else
      ngrams[second, third] / q2_denominator.to_f
    end

    q3 = if (q3_denominator = ngrams[first, second]).zero?
      0
    else
      ngrams[first, second, third] / q3_denominator.to_f
    end

    q1 * interpolations[0] + q2 * interpolations[1] + q3 * interpolations[2]
  end

  # Function e in the Viterbi algorithm. It process probability of
  # generation word with this tag relatively to all words with
  # this tag.
  #
  def e(word, tag)
    return 0.0 if ngrams[tag].zero?
    lexicon[word, tag] / ngrams[tag].to_f
  end

  # If word is rare, than it should be replaced in preparation of the
  # training set. So, it can't be in the training set.
  #
  def rare?(word)
    lexicon[word] <= 1
  end

  protected
  # Count coefficients for linear interpolation for evaluating
  # q(first, second, third).
  #
  def compute_interpolations!
    lambdas = [0.0, 0.0, 0.0]

    ngrams.each_trigram do |(first, second, third), count|
      f1_denominator = ngrams.unigrams_count - 1
      f1 = if f1_denominator.zero?
        0
      else
        (ngrams[third] - 1) / f1_denominator.to_f
      end

      f2_denominator = ngrams[second] - 1
      f2 = if f2_denominator.zero?
        0
      else
        (ngrams[second, third] - 1) / f2_denominator.to_f
      end

      f3_denominator = ngrams[first, second] - 1
      f3 = if f3_denominator.zero?
        0
      else
        (count - 1) / f3_denominator.to_f
      end

      if f1 > f2 && f1 > f3
        lambdas[0] += count
      elsif f2 > f1 && f2 > f3
        lambdas[1] += count
      elsif f3 > f1 && f3 > f2
        lambdas[2] += count
      end
    end

    total = lambdas.inject(&:+)
    @interpolations = lambdas.map! { |l| l / total }
  end
end

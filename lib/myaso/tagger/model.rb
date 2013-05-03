# encoding: utf-8

# Any HMM tagger requires a trained model that can perform such tasks as
# producing smoothed q() and e() values, replace unknown words with special
# symbols.
#
class Myaso::Tagger::Model
  # A start tag for a sentence.
  #
  START = 'SENT'

  # A stop tag for a sentence.
  #
  STOP = 'SENT'

  # Unknown tag for token.
  #
  MISSING = '-'

  # Tokens consisting of a sequence of decimal digits.
  #
  CARD = '@CARD'

  # Decimal digits followed by punctuation.
  #
  CARDPUNCT = '@CARDPUNCT'

  # Decimal digits followed by any suffix.
  #
  CARDSUFFIX = '@CARDSUFFIX'

  # Decimal digits separated by dots, dashes, etc.
  #
  CARDSEPS = '@CARDSEPS'

  # Tag frequencies to handle unknown words.
  #
  UNKNOWN = '@UNKNOWN'

  attr_reader :ngrams_path, :lexicon_path, :ngrams, :lexicon

  # Coefficients for linear interpolation.
  #
  attr_reader :interpolations

  # The tagging model is initialized by two data files. The first one is a
  # n-grams file that stores statistics for unigrams, bigrams, trigrams.
  # The second one is a lexicon file that stores words and their
  # frequencies in the source corpus.
  #
  # Please note that the learning stage is not so optimized, so the
  # initialization procedure may take about 120 seconds.
  #
  def initialize(ngrams_path, lexicon_path)
    @ngrams_path = File.expand_path(ngrams_path)
    @lexicon_path = File.expand_path(lexicon_path)
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

  # @private
  #
  def inspect
    sprintf('#<%s ngrams_path=%s lexicon_path=%s>', self.class.name,
      ngrams_path, lexicon_path)
  end

  # If word is rare, than it should be replaced in preparation of the
  # training set. So, it can't be in the training set.
  #
  def rare?(word)
    lexicon[word] <= 1
  end

  # If word is rare, it can be one of the following categories:
  # includes numbers, numbers and punctuation symbols, non-numbers
  # following numbers and unknown. Otherwise, word has it's own category.
  #
  def classify(word)
    return word unless rare? word
    case word
    when /^\d+$/ then CARD
    when /^\d+[.,;:]+$/ then CARDPUNCT
    when /^\d+\D+$/ then CARDSUFFIX
    when /^\d+[.,;:\-]+(\d+[.,;:\-]+)*\d+$/ then CARDSEPS
    else UNKNOWN
    end
  end

  # Tagger requires the sentence start symbol to be defined.
  #
  def start_symbol
    START
  end

  # Tagger requires the sentence stop symbol to be defined.
  #
  def stop_symbol
    STOP
  end

  protected
  # Parse n-grams and lexicon files, and compute statistics over them.
  #
  def learn!
    parse_ngrams!
    parse_lexicon!
    compute_interpolations!
  end

  # Parse the n-grams file.
  #
  def parse_ngrams!
    unigram, bigram = nil, nil

    read(ngrams_path) do |values|
      if !values[0] && !values[1]
        values[0], values[1] = unigram, bigram
      elsif !values[0] && values[1]
        values[0] = unigram
      end

      if values[0] && values[1] && values[2] && values[3] # a trigram
        ngrams[*values[0..2]] = values[3].to_i
      elsif values[0] && values[1] && values[2] && !values[3] # a bigram
        ngrams[*values[0..1]] = values[2].to_i
      elsif values[0] && values[1] && !values[2] && !values[3] # an unigram
        ngrams[values[0]] = values[1].to_i
      else
        raise 'dafuq i just read: %s' % values.inspect
      end

      unigram, bigram = values[0], values[1]
    end
  end

  # Parse the lexicon file.
  #
  def parse_lexicon!
    read(lexicon_path) do |values|
      values.compact!

      word, word_count, rare = values.shift, values.shift.to_i, false
      word = classify(word) if rare = (word_count == 1)

      lexicon[word] += word_count

      values.each_slice(2) do |tag, count|
        lexicon[word, tag] += count.to_i
      end
    end
  end

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

  def read(path)
    File.open(path) do |f|
      until f.eof?
        line = f.gets.chomp
        next if line.empty? || line =~ /^%%/
        yield line.split(/\t/).map! { |s| s.empty? ? nil : s }
      end
    end
  end
end

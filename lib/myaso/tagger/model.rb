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

  attr_reader :ngrams_path, :lexicon_path

  # 1,2,3-grams are arrays of nested structures
  # kind of (:value, :tags, :count).
  #
  attr_reader :ngrams

  # Training set with words and tags always has a huge size.
  # So there is a good idea to split it to groups. With this
  # approach to find word we chould find group of word at
  # first and find word in group at second. It is faster,
  # because number of groups and number of words are much less
  # than size of array with all words.
  # It is obviously to choose the first char of word as criterium
  # of grouping. We can see, to which group the word belongs.
  #
  # @words_tags is array of objects, that has the following nature:
  # [first_char, [*Word]]
  #
  attr_reader :words_tags

  # Counts of total using words are stored in separate array.
  #
  attr_reader :words_counts

  # Coefficients for linear interpolation.
  #
  attr_reader :interpolations

  # Total count of trigrams.
  #
  attr_reader :total_count

  # The tagging model is initialized by two data files. The first one is a
  # n-grams file that stores statistics for unigrams, bigrams, trigrams.
  # The second one is a lexicon file that stores words and their
  # frequencies in the source corpus.
  #
  # Please note that the learning stage is not so optimized, so the
  # initialization procedure may take about 120 seconds.
  #
  def initialize(ngrams_path, lexicon_path)
    @ngrams, @words_tags, @words_counts = Myaso::Ngrams.new, [], []

    @ngrams_path = File.expand_path(ngrams_path)
    @lexicon_path = File.expand_path(lexicon_path)

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
    q1 = if (q1_denominator = total_count).zero?
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
    count(word, tag) / ngrams[tag]
  end

  # @private
  #
  def inspect
    '#<%s ngrams_path=%s lexicon_path=%s' % [self.class.name,
      ngrams_path, lexicon_path]
  end

  # If word is rare, than it should be replaced in
  # preparation of the training set. So, it can't be in the training set.
  #
  def rare?(word)
    candidate = @words_counts.find { |fc, w| fc == word[0] }
    candidate = candidate.last.find { |w,c| w == word } if candidate
    !candidate || candidate.last == 1
  end

  # If word is rare, it can be one of the following categories:
  # includes numbers, numbers and punctuation symbols, non-numbers
  # following numbers and unknown. Otherwise, word has it's own category.
  #
  def classify(word)
    return word unless rare?(word)
    case word
    when /^\d+$/ then CARD
    when /^\d+[.,;:]+$/ then CARDPUNCT
    when /^\d+\D+$/ then CARDSUFFIX
    when /^\d+[.,;:\-]+(\d+[.,;:\-]+)*\d+$/ then CARDSEPS
    else UNKNOWN
    end
  end

  # Find count for given bunch (word => tag).
  #
  def count(word, tag)
    word = words_tags.find { |fc, w| fc == word[0] }.last.
      find { |t| t.tag == tag and t.word == word }
    return 0 unless word
    word.count
  end

  # Find tags for given word.
  #
  def tags(word)
    _, words = words_tags.find { |fc, w| fc == word[0] }
    raise UnknownWord.new(word) unless words
    words.select { |w| w.word == word }.map(&:tag)
  end

  def start_symbol
    START
  end

  def stop_symbol
    STOP
  end

  protected
  # Parse path files and fill @ngrams, @words_tags.
  #
  def learn!
    # Parse file with ngrams.
    strings = IO.readlines(ngrams_path).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }
    @total_count = 0.0

    last_unigram, last_bigram = nil, nil

    strings.each do |string|
      tag, count = string.split
      count = count.to_i

      if string[0] == "\t"
        if string[1] == "\t"
          # a trigram
          ngrams[last_unigram, last_bigram, tag] = count
        else
          # a bigram
          ngrams[last_unigram, tag] = count
          last_bigram = tag
        end
      else
        # an unigram
        ngrams[tag] = count
        last_unigram = tag
        @total_count += count.to_f
      end
    end

    # Parse file with words and tags.
    IO.readlines(lexicon_path).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }.
      map(&:split).each do |tokens|
        word, word_count = tokens.shift, tokens.shift
        word_count = word_count.to_i
        word = classify(word) if word_count == 1

        char_index = words_counts.index {|(fc, _)| fc == word[0] }
        if char_index
          word_index = words_counts[char_index].last.index { |(w, _)| w == word }
          if word_index
            words_counts[char_index].last[word_index][1] += word_count
          else
            words_counts[char_index].last << [word, word_count]
          end
        else
          words_counts << [word[0], [[word, word_count]]]
        end

        this_char = words_tags.index { |(fc, _)| fc == word[0] }

        tokens.each_slice(2) do |tag, count|
          if this_char
            this_tag = words_tags[this_char].last.index do |w|
              w.word == word and w.tag == tag
            end
            if this_tag
              words_tags[this_char].last[this_tag].count += count.to_f
            else
              words_tags[this_char].last << Myaso::Word.new(word, tag, count.to_f)
            end
          else
            this_char = words_tags.size
            words_tags << [word[0], [Myaso::Word.new(word, tag, count.to_f)]]
          end
        end
      end

    compute_interpolations!
  end

  # Count coefficients for linear interpolation for evaluating
  # q(first, second, third).
  #
  def compute_interpolations!
    lambdas = [0.0, 0.0, 0.0]

    ngrams.each do |first, bigrams|
      bigrams.each do |second, trigrams|
        next unless second

        trigrams.each do |third, count|
          next unless third

          f1_denominator = total_count - 1
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
            (ngrams[first, second, third] - 1) / f3_denominator.to_f
          end

          if f1 > f2 && f1 > f3
            lambdas[0] += ngrams[first, second, third]
          elsif f2 > f1 && f2 > f3
            lambdas[1] += ngrams[first, second, third]
          elsif f3 > f1 && f3 > f2
            lambdas[2] += ngrams[first, second, third]
          end
        end
      end
    end

    total = lambdas.inject(&:+)
    @interpolations = lambdas.map! { |l| l / total }
  end
end

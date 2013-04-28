# encoding: utf-8

# This class is an implementation of the Viterbi algorithm.
#
class Myaso::Tagger
  # The UnknownWord exception is raised when Tagger considers an unknown
  # word.
  #
  class UnknownWord < RuntimeError
    attr_reader :word

    # @private
    def initialize(word)
      @word = word
    end

    # @private
    def to_s
      'unknown word "%s"' % word
    end
  end

  # The Ngram structure is an uniform representation of an unigram,
  # a bigram, or a trigram.
  #
  Ngram = Struct.new(:value, :tags, :count)

  # The Word structure represents frequencies of tagged words.
  #
  Word = Struct.new(:word, :tag, :count)

  # The Point structure is a wrapper of rows in both dynamic programming
  # and backpoints tables.
  #
  Point = Struct.new(:index, :u, :v, :value)

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

  # Coefficients for linear interpolation.
  #
  attr_reader :interpolations

  # Total count of trigrams.
  attr_reader :total_count

  # A start tag for a sentence.
  #
  START = 'SENT'

  # A stop tag for a sentence.
  #
  STOP = 'SENT'

  # Different special tags.
  #
  CARD, CARDPUNCT, CARDSUFFIX, CARDSEPS, UNKNOWN =
    %w(@CARD @CARDPUNCT @CARDSUFFIX @CARDSEPS @UNKNOWN)

  # Tagger is initialized by two data files. The first one is a
  # n-grams file that stores statistics for unigrams, bigrams, trigrams.
  # The second one is a lexicon file that stores words and their
  # frequencies in the source corpus.
  #
  # Please note that the Tagger learning stage is not optimized, so the
  # initialization procedure may take about 120 seconds.
  #
  def initialize(ngrams_path, lexicon_path)
    @ngrams, @words_tags = [], []

    @ngrams_path = File.expand_path(ngrams_path)
    @lexicon_path = File.expand_path(lexicon_path)

    learn!
  end

  # Viterbi algorithm itself. Return tags that input sentence
  # should be annotated.
  #
  def annotate(sentence)
    return [] if sentence.size == 0

    tags_first = [START]
    pi_table, bp_table = [Point.new(1, START, START, 0.0)], []

    sentence = sentence.dup
    sentence.unshift(START, START)

    sentence.each_with_index.each_cons(3) do |(w1, i1), (w2, i2), (w3, index)|
      word = classify_word(w3)
      w_tags = (i1 < 2) ? tags_first : tags(w1)
      u_tags = (i2 < 2) ? tags_first : tags(w2)
      v_tags = tags(word)

      u_tags.product(v_tags).each do |u, v|
        p, b = Point.new(index, u, v, :value), Point.new(index, u, v, :value)

        p.value, b.value = w_tags.map do |w|
          unless pi(pi_table, index - 1, w, u).finite?
            next [-Float::INFINITY, w]
          end

          [pi(pi_table, index - 1, w, u) + Math.log2(q(w, u, v) *
            e(word, v)), w]
        end.max_by { |pi, _| pi }

        pi_table << p
        bp_table << b
      end
    end

    y = []
    size = sentence.size - 1
    if size.zero?
      v_tags = tags(sentence[-1])
      return tags_first.product(v_tags).
        max_by { |u, v| pi(size, u, v) + Math.log2(q(u, v, STOP)) }.last
    end

    u_tags = tags(sentence[-2])
    v_tags = tags(sentence[-1])
    y[size - 1], y[size] = u_tags.product(v_tags).
      max_by { |u, v| pi(pi_table, size, u, v) + Math.log2(q(u, v, STOP)) }

    size.downto(4) do |index|
      y[index - 2] = bp(bp_table, index, y[index - 1], y[index])
    end

    y[2..-1]
  end

  # @private
  #
  def inspect
    '#<%s ngrams_path=%s lexicon_path=%s' % [self.class.name,
      ngrams_path, lexicon_path]
  end

  # Function e in the Viterbi algorithm. It process probability of
  # generation word with this tag relatively to all words with
  # this tag.
  #
  def e(word, tag)
    return 0 if ngram(tag).zero?
    count(word, tag) / ngram(tag)
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
    score = Array.new(3)

    if total_count.zero?
      return 0
    else
      score[2] = (ngram(third) / total_count) * interpolations[0]
    end

    if (den = ngram(first, second)).zero?
      score[0] = 0
    else
      score[0] = (ngram(first, second, third) / den) * interpolations[1]
    end

    if (den = ngram(second)).zero?
      score[1] = 0
    else
      score[1] = (ngram(second, third) / den) * interpolations[2]
    end

    score.inject(&:+)
  end

  private
  # Parse path files and fill @ngrams, @words_tags.
  #
  def learn!
    # Parse file with ngrams.
    strings = IO.readlines(ngrams_path).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }
    @total_count = 0.0

    strings.each do |string|
      tag, count = string.split
      if string[0] == "\t"
        if string[1] == "\t"
          # It is trigram.
          ngrams.last.tags.last.tags << Ngram.new(tag, nil, count.to_f)
        else
          # It is bigram.
          ngrams.last.tags << Ngram.new(tag, [], count.to_f)
        end
      else
        # It is unigram.
        @total_count += count.to_f
        ngrams << Ngram.new(tag, [], count.to_f)
      end
    end

    # Parse file with words and tags.
    IO.readlines(lexicon_path).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }.
      map(&:split).each do |string|
        word, _ = string.shift, string.shift

        this_char = words_tags.each_with_index.find do |(first_char, _), index|
          first_char == word[0]
        end

        string.each_slice(2) do |tag, count|
          if this_char
            words_tags[this_char.last].last << Word.new(word, tag, count.to_f)
          else
            words_tags << [word[0], [Word.new(word, tag, count.to_f)]]
          end
        end
      end

      compute_interpolations!
  end

  # Count coefficients for linear interpolation for
  # evaluating q(first, second, third).
  def compute_interpolations!
    interpolations = [0, 0, 0]
    ngrams.each do |unigram|
      unigram.tags.each do |bigram|
        bigram.tags.each do |trigram|
          score = Array.new(3)

          if (bigram.count - 1).zero?
            score[0] = 0
          else
            score[0] = (trigram.count - 1) / (bigram.count - 1)
          end

          if (den = ngram(bigram.value) - 1).zero?
            score[1] = 0
          else
            score[1] = (ngram(bigram.value, trigram.value) - 1) / den
          end

          if (@total_count - 1).zero?
            score[2] = 0
          else
            score[2] = (ngram(trigram.value) - 1) / (@total_count - 1)
          end

          max = score.each_with_index.max_by { |v, _| v }.last
          interpolations[max] += 1
        end
      end
    end
    sum = interpolations.inject(&:+).to_f
    @interpolations = interpolations.map { |v| v / sum }
  end

  # If word is rare, than it should be replaced in
  # preparation of the training set. So, it can't be in the training set.
  #
  def rare?(word)
    @words_tags.find { |fc, w| fc == word[0] }.last.
      find { |w| w.word == word }.nil?
  end

  # If word is rare, it can be one of the following categories:
  # includes numbers, numbers and punctuation symbols, non-numbers
  # following numbers and unknown. Otherwise, word has it's own category.
  #
  def classify_word(word)
    return word unless rare?(word)
    case word
    when /^\d+$/ then CARD
    when /^\d+[.,;:]+$/ then CARDPUNCT
    when /^\d+\D+$/ then CARDSUFFIX
    when /^\d+[.,;:\-]+(\d+[.,;:\-]+)*\d+$/ then CARDSEPS
    else UNKNOWN
    end
  end

  # Find count of ngram with given tags.
  #
  def ngram(*tag)
    gram = ngrams.find { |t| t.value == tag.first }
    gram = gram.tags.find { |t| t.value == tag[1] } if tag.size > 1
    gram = gram.tags.find { |t| t.value == tag[2] } if tag.size > 2
    return 0 unless gram
    gram.count
  end

  # Find count for given bunch (word => tag).
  #
  def count(word, tag)
    word = words_tags.find { |fc, w| fc == word[0] }.last.
      find { |t| t.tag == tag and t.word == word }
    return 0 unless word
    word.count
  end

  # Find pi_table(index, u, v).
  #
  def pi(pi_table, index, u, v)
    pi_table.find { |pi| pi.index == index and pi.u == u and pi.v == v }.value
  end

  # Find backpoints(index, u, v).
  #
  def bp(bp_table, index, u, v)
    bp_table.find { |bp| bp.index == index and bp.u == u and bp.v == v }.value
  end

  # Find tags for given word.
  #
  def tags(word)
    _, words = words_tags.find { |fc, w| fc == word[0] }
    raise UnknownWord.new(word) unless words
    words.select { |w| w.word == word }.map(&:tag)
  end
end

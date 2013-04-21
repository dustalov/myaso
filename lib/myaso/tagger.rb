# encoding: utf-8

# This class implements Viterbi algorithm.
#
class Viterbi
  attr_accessor :ngrams, :words_tags

  # Start and stop tags for sentence.
  START, STOP = 'SENT', 'SENT'

  # Special tags, used for replacing of rare words.
  CARD, CARDPUNCT, CARDSUFFIX, CARDSEPS, UNKNOWN =
  %w(@CARD @CARDPUNCT @CARDSUFFIX @CARDSEPS @UNKNOWN)

  def initialize(ngrams_path, words_path)
    # 1,2,3-grams are arrays of nested structures
    # kind of (:value, :tags, :count).
    #
    @ngrams = []

    # Training set with words and tags always has a huge size.
    # So there is a good idea to split it to groups. With this
    # approach to find word we chould find group of word at
    # first and find word in group at second. It is faster,
    # because number of groups and number of words are much less
    # than size of array with all words.
    # It is obviously to choose the first char of word as criterium
    # of grouping. We can see, to which group the word belongs.
    # @words_tags is array of objects, that has the following nature:
    # [first_char, [*Words]]
    @words_tags = []

    learn! ngrams_path, words_path
  end

  # Viterbi algorithm itself. Return tags that input sentence
  # should be marked.
  #
  def viterbi(sentence)
    return [] if sentence.size == 0
    tags_first = [START]
    pi_table = [Point.new(1, START, START, 0.0)]
    backpoints = []
    sentence.unshift(START, START)

    sentence.each_with_index.each_cons(3) do |(w1, i1), (w2, i2), (w3, index)|
      word = classify_word(w3)
      w_tags = (i1 < 2) ? tags_first : tags(w1)
      u_tags = (i2 < 2) ? tags_first : tags(w2)
      v_tags = tags(word)

      u_tags.product(v_tags).each do |u, v|
        p, b = Point.new(index, u, v, :value), Point.new(index, u, v, :value)
        p.value, b.value = w_tags.map do |w|
          next([-Float::INFINITY, w]) unless pi(pi_table, index - 1, w, u).finite?
          [pi(pi_table, index - 1, w, u) + Math.log2(q(w, u, v) * e(word, v)), w]
        end.max_by { |pi, bp| pi } # w
        pi_table << p
        backpoints << b
      end # u, v
    end # word

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
      y[index - 2] = bp(backpoints, index, y[index - 1], y[index])
    end
    y[2..-1]
  end

  private

  # Parse path files and fill @tags, @bigrams, @trigrams, @tags.
  #
  def learn!(ngrams_path, words_path)
    # Parse file with ngrams.
    strings = IO.readlines(File.expand_path(ngrams_path)).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }

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
        ngrams << Ngram.new(tag, [], count.to_f)
      end
    end

    # Parse file with words and tags.
    IO.readlines(File.expand_path(words_path)).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }.
      map(&:split).each do |string|
        word, _ = string.shift, string.shift
        this_char = words_tags.each_with_index.
          find { |(fc, _), i| fc == word[0] }

        string.each_slice(2) do |tag, count|
          if this_char
            words_tags[this_char.last].last << Words.new(word, tag, count.to_f)
          else
            words_tags << [word[0], [Words.new(word, tag, count.to_f)]]
          end
        end
      end
  end

  # If word is rare, than it should be replaced in
  # preparation of the training set. So, it can't be in the training set.
  #
  def rare?(word)
    @words_tags.find { |fc, w| fc == word[0] }.last.
      find { |w| w.word == word }.nil?
  end

  # If word is rare, it can be one of the following categories:
  # includes numbers, all symbols are capital, the last symbol
  # is capital and other. Otherwise, word has it's own category.
  #
  def classify_word(word)
    return word unless rare?(word)
    case word
    when /\d+/
      CARD
    when /^\d*\./
      CARDPUNCT
    when /^\d+D+/
      CARDSUFFIX
    when /\d*(\.|\\|\/|:)*/
      CARDSEPS
    else
      UNKNOWN
    end
  end

  # Function e in viterby algorithm. It process probability of
  # generation word with this tag relatively to all words with
  # this tag.
  #
  def e(word, tag)
    return 0 if ngram(tag).zero?
    count(word, tag) / ngram(tag)
  end

  # Maximum likeness model of processing attitude between trigram
  # (a, b, c) and bigram (a, b). It have the next sense:
  # probability that current tag is (c) if last two are (a, b).
  #
  def q(first, second, third)
    return 0 if ngram(first, second).zero?
    ngram(first, second, third) / ngram(first, second)
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
  def bp(backpoints, index, u, v)
    backpoints.find { |bp| bp.index == index and bp.u == u and bp.v == v }.value
  end

  # Find tags for given word.
  #
  def tags(word)
    words_tags.find { |fc, w| fc == word[0] }.last.
      select { |w| w.word == word}.map { |t| t.tag }
  end
end

Ngram = Struct.new(:value, :tags, :count)
Words = Struct.new(:word, :tag, :count)
Point = Struct.new(:index, :u, :v, :value)

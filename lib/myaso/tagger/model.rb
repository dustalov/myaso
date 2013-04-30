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
    @ngrams, @words_tags, @words_counts = [], [], []

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

  # Function e in the Viterbi algorithm. It process probability of
  # generation word with this tag relatively to all words with
  # this tag.
  #
  def e(word, tag)
    return 0 if ngram(tag).zero?
    count(word, tag) / ngram(tag)
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

  # Find count of ngram with given tags.
  #
  def ngram(*tag)
    gram = ngrams.find { |t| t.value == tag.first }
    gram = gram.tags.find { |t| t.value == tag[1] } if tag.size > 1 && gram
    gram = gram.tags.find { |t| t.value == tag[2] } if tag.size > 2 && gram
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

    strings.each do |string|
      tag, count = string.split
      if string[0] == "\t"
        if string[1] == "\t"
          # It is trigram.
          ngrams.last.tags.last.tags << Myaso::Ngram.new(tag, nil, count.to_f)
        else
          # It is bigram.
          ngrams.last.tags << Myaso::Ngram.new(tag, [], count.to_f)
        end
      else
        # It is unigram.
        @total_count += count.to_f
        ngrams << Myaso::Ngram.new(tag, [], count.to_f)
      end
    end

    # Prepare @words_tags, @words_counts.
    unknown_words = [CARD, CARDPUNCT, CARDSUFFIX, CARDSEPS, UNKNOWN]
    @words_tags, @words_counts = [['@', []]], [['@', []]]
    unknown_words.each do |word|
      words_tags[0].last << Myaso::Word.new(word, MISSING, 0)
      words_counts[0].last << [word, 0]
    end

    # Parse file with words and tags.
    IO.readlines(lexicon_path).map(&:chomp).
      delete_if { |s| s.empty? || s[0..1] == '%%' }.
      map(&:split).each do |tokens|
        rare = false
        word, word_count = tokens.shift, tokens.shift
        word_count = word_count.to_i
        if word_count == 1
          word = classify(word)
          rare = true
        end

        if rare
          index = unknown_words.index(word)
          words_counts[0].last[index][1] += word_count
        else
          char_index = words_counts.index {|(fc, _)| fc == word[0] }
          if char_index
            words_counts[char_index].last << [word, word_count]
          else
            words_counts << [word[0], [[word, word_count]]]
          end
        end

        if rare
          this_char = 0
        else
          this_char = words_tags.index { |(fc, _)| fc == word[0] }
        end

        tokens.each_slice(2) do |tag, count|
          count = count.to_f
          if rare
            this_tag = words_tags[this_char].last.index do |w|
              w.word == word and w.tag == tag
            end
            if this_tag
              words_tags[this_char].last[this_tag].count += count
            else
              words_tags[this_char].last << Myaso::Word.new(word, tag, count)
            end
          else
            if this_char
              words_tags[this_char].last << Myaso::Word.new(word, tag, count)
            else
              this_char = words_tags.size
              words_tags << [word[0], [Myaso::Word.new(word, tag, count)]]
            end
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
end

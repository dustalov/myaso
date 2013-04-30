# encoding: utf-8

require 'forwardable'

require 'myaso/version'
require 'myaso/pi_table'
require 'myaso/ngrams'
require 'myaso/tagger'
require 'myaso/tagger/model'

# The UnknownWord exception is raised when Tagger considers an unknown
# word.
#
class Myaso::UnknownWord < RuntimeError
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
Myaso::Ngram = Struct.new(:value, :tags, :count)

# The Word structure represents frequencies of tagged words.
#
Myaso::Word = Struct.new(:word, :tag, :count)

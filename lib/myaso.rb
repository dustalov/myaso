# encoding: utf-8

require 'myaso/version'
require 'myaso/pi_table'
require 'myaso/tagger'
require 'myaso/tagger/model'

# The Ngram structure is an uniform representation of an unigram,
# a bigram, or a trigram.
#
Myaso::Ngram = Struct.new(:value, :tags, :count)

# The Word structure represents frequencies of tagged words.
#
Myaso::Word = Struct.new(:word, :tag, :count)

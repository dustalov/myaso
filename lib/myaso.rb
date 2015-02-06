# encoding: utf-8

require 'forwardable'
require 'ffi'

require 'myaso/version'
require 'myaso/pi_table'
require 'myaso/ngrams'
require 'myaso/lexicon'
require 'myaso/tagger'
require 'myaso/tagger/model'
require 'myaso/tagger/tnt'
require 'myaso/mystem'

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

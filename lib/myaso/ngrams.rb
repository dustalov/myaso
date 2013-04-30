# encoding: utf-8

# A simple yet handy implementation of a n-gram storage.
#
class Myaso::Ngrams
  extend Forwardable
  include Enumerable

  attr_reader :table
  def_delegator :@table, :each, :each

  attr_reader :ngrams

  # An instance of a n-gram storage is initialized by zero counts.
  #
  def initialize
    @table = Hash.new do |h, k|
      h[k] = Hash.new { |h, k| h[k] = Hash.new(0) }
    end
  end

  # Obtain the count of the specified unigram, bigram, or trigram.
  #
  def [] *ngram
    u, b, t = ngram
    return 0 unless table.include? u
    return 0 unless table[u].include? b
    table[u][b][t]
  end

  # Assign the count to the specified unigram, bigram, or trigram.
  #
  def []= *ngram, count
    u, b, t = ngram
    table[u][b][t] = count
  end

  # Two storages are equal iff they tables are equal.
  #
  def == other
    self.table == other.table
  end
end

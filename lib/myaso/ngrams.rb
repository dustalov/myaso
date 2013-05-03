# encoding: utf-8

# A simple yet handy implementation of a n-gram storage.
#
class Myaso::Ngrams
  extend Forwardable
  include Enumerable

  attr_reader :table
  def_delegator :@table, :each, :each

  # An instance of a n-gram storage is initialized by zero counts.
  #
  def initialize
    @table = Hash.new do |h, k|
      h[k] = Hash.new { |h, k| h[k] = Hash.new(0) }
    end
  end

  # Obtain the count of the specified unigram, bigram, or trigram.
  #
  def [] unigram, bigram = nil, trigram = nil
    return 0 unless table.include? unigram
    return 0 unless table[unigram].include? bigram
    table[unigram][bigram][trigram]
  end

  # Assign the count to the specified unigram, bigram, or trigram.
  #
  def []= unigram, bigram = nil, trigram = nil, count
    table[unigram][bigram][trigram] = count
  end

  # Two storages are equal iff they tables are equal.
  #
  def == other
    self.table == other.table
  end

  # Trigrams enumerator. Yes, this method should return an Enumerator
  # instance, but it is too slow.
  #
  def each_trigram
    table.each do |unigram, bigrams|
      bigrams.each do |bigram, trigrams|
        next unless bigram

        trigrams.each do |trigram, count|
          next unless trigram

          yield [[unigram, bigram, trigram], count]
        end
      end
    end
  end

  # Unigrams count.
  #
  def unigrams_count
    table.keys.inject(0) do |count, unigram|
      count + table[unigram][nil][nil]
    end
  end
end

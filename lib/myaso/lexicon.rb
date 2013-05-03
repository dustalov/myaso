# encoding: utf-8

# A pretty useful representation of a lexicon in the following form:
# `word_prefix -> word -> tags`.
#
class Myaso::Lexicon
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

  # Obtain the count of the specified word and tag.
  #
  def [] word, tag = nil
    return 0 unless table.include? prefix(word)
    return 0 unless table[prefix(word)].include? word
    table[prefix(word)][word][tag]
  end

  # Assign the count to the specified word and tag.
  #
  def []= word, tag = nil, count
    @tags = nil
    table[prefix(word)][word][tag] = count
  end

  # Retrieve global tags or tags of the given word.
  #
  def tags(word = nil)
    return lazy_aggregated_tags unless word
    table[prefix(word)][word].keys.compact
  end

  # Two lexicons are equal iff they tables are equal.
  #
  def == other
    self.table == other.table
  end

  protected
  # Perform lazy initialization of global tags.
  #
  def lazy_aggregated_tags
    @tags ||= table.inject(Hash.new(0)) do |hash, (prefix, wts)|
      wts.each do |word, tags|
        tags.each do |tag, count|
          next unless tag
          hash[tag] += count
        end
      end

      hash
    end
  end

  # Extract the word prefix of three characters.
  #
  def prefix(word)
    word[0..2]
  end
end

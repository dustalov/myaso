# encoding: utf-8

# A simple implementation of a dynamic programming table in the following
# form: $\pi(i, u, v)$. where $i$ is an index and $u, v$ are elements of
# a finite set of tags.
#
class Myaso::PiTable
  extend Forwardable
  include Enumerable

  attr_reader :default, :table
  def_delegator :@table, :each, :each

  # An instance of a dynamic programming table can consider the specified
  # default value.
  #
  def initialize(default = nil)
    @default = default
    @table = Hash.new do |h, k|
      h[k] = Hash.new { |h, k| h[k] = Hash.new(default) }
    end
  end

  # Obtain the value of $\pi(i, u, v)$ or return the default value if it
  # is nil.
  #
  def [] i, u, v
    table[i][u][v]
  end

  # Set a value of $\pi(i, u, v)$.
  #
  def []= i, u, v, value
    table[i][u][v] = value
  end
end

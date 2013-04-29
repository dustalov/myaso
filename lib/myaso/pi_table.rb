# encoding: utf-8

# A simple implementation of dynamic programming table in the following
# form: $\pi(i, u, v)$. where $i$ is an index and $u, v$ are elements of
# a finite set of tags.
#
class Myaso::PiTable
  # Row structure is a wrapper of a row in the programming table.
  #
  Row = Struct.new(:i, :u, :v, :value)

  attr_reader :table, :default

  # An instance of dynamic programming table can consider the specified
  # default value.
  #
  def initialize(default = nil)
    @table, @default = [], default
  end

  # Obtain the value of $\pi(i, u, v)$ or return the default value if it
  # is nil.
  #
  def [] i, u, v
    if row = obtain(i, u, v)
      row.value
    else
      default
    end
  end

  # Set a value of $\pi(i, u, v)$.
  #
  def []= i, u, v, value
    if row = obtain(i, u, v)
      row.value = value
    else
      table << Row.new(i, u, v, value)
    end

    value
  end

  protected
  # Obtain the value of $\pi(i, u, v)$ or return nil.
  #
  def obtain(i, u, v)
    table.find { |row| row.i == i && row.u == u && row.v == v }
  end
end

# encoding: utf-8

# An Adapter that connects with {Myaso::Base Myaso::Bases}.
#
class Myaso::Adapter
  attr_reader :base
  protected :base

  # Create a new instance of Myaso::Adapter.
  #
  # @param base [Myaso::Base] a base to connect.
  #
  def initialize base
    @base = base
  end
end

# encoding: utf-8

class Myaso::Base::Adapter
  attr_reader :base
  protected :base

  def initialize base
    @base = base
  end
end

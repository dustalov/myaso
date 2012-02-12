# encoding: utf-8

class Myaso::Adapter
  attr_reader :client
  protected :client

  def initialize client
    @client = client
  end
end

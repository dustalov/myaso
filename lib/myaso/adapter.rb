# encoding: utf-8

# An Adapter that connects with {Myaso::Client Myaso::Clients}.
#
class Myaso::Adapter
  attr_reader :client
  protected :client

  # Create a new instance of Myaso::Adapter.
  #
  # @param client [Myaso::Client] a client to connect.
  #
  def initialize client
    @client = client
  end
end

module Kamerling class Mapper
  def initialize client
    @client = client
  end

  def to_h
    client.to_h
  end

  attr_reader :client
  private     :client
end end

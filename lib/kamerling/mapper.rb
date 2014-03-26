module Kamerling class Mapper
  def self.to_h object
    object.to_h
  end

  def initialize client
    @client = client
  end

  def to_h
    client.to_h
  end

  attr_reader :client
  private     :client
end end

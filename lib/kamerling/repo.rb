module Kamerling class Repo
  def initialize source
    @source = source
  end

  def << object
    source << object.to_h
  end

  attr_reader :source
  private     :source
end end

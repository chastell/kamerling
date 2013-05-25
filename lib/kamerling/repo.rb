module Kamerling class Repo
  def initialize source, klass
    @klass, @source = klass, source
  end

  def << object
    source << object.to_h
  end

  def [] uuid
    if hash = source[uuid: uuid]
      klass[hash]
    end
  end

  attr_reader :klass, :source
  private     :klass, :source
end end

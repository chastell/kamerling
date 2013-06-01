module Kamerling class Repo
  NotFound = Class.new RuntimeError

  def initialize source, klass
    @klass, @source = klass, source
  end

  def << object
    source << object.to_h
  rescue Sequel::UniqueConstraintViolation
    source.where(uuid: object.uuid).update object.to_h
  end

  def [] uuid
    if hash = source[uuid: uuid]
      klass.from_h hash
    else
      raise NotFound, "#{klass} with UUID #{uuid}"
    end
  end

  attr_reader :klass, :source
  private     :klass, :source
end end

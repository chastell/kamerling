module Kamerling class Repo
  NotFound = Class.new RuntimeError

  def initialize klass, source
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

  def all
    source.all.map { |hash| klass.from_h hash }
  end

  def related_to object
    key = "#{object.class.name.split('::').last.downcase}_uuid".to_sym
    source.where(key => object.uuid).map { |hash| klass.from_h hash }
  end

  attr_reader :klass, :source
  private     :klass, :source
end end

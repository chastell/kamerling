module Kamerling class Repo
  NotFound = Class.new RuntimeError

  def initialize klass, source, mapper: Mapper
    @klass  = klass
    @mapper = mapper
    @source = source
  end

  def << object
    hash = mapper.to_h object
    warn_off { source << hash }
  rescue Sequel::UniqueConstraintViolation
    warn_off { source.where(uuid: object.uuid).update hash }
  end

  def [] uuid
    hash = warn_off { source[uuid: uuid] }
    fail NotFound, "#{klass} with UUID #{uuid}" unless hash
    klass.from_h hash
  end

  def all
    source.all.map { |hash| klass.from_h hash }
  end

  def related_to object
    key = "#{object.class.name.split('::').last.downcase}_uuid".to_sym
    source.where(key => object.uuid).map { |hash| klass.from_h hash }
  end

  attr_reader :klass, :mapper, :source
  private     :klass, :mapper, :source
end end

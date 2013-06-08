module Kamerling class Project
  class << self
    alias [] new
  end

  def self.from_h hash
    new name: hash[:name], uuid: hash[:uuid]
  end

  attr_reader :name, :uuid

  def initialize name: req(:name), uuid: UUID.new
    @name, @uuid = name, uuid
  end

  def == other
    uuid == other.uuid
  end

  def to_h
    { name: name, uuid: uuid }
  end
end end

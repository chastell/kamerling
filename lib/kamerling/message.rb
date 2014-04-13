require_relative 'uuid'

module Kamerling class Message
  UnknownType = Class.new RuntimeError

  def self.[] client: req(:client), payload: req(:payload),
              project: req(:project), task: req(:task), type: req(:type)
    new "#{type}\0\0\0\0\0\0\0\0\0\0\0\0" + UUID.bin(client.uuid) +
      UUID.bin(project.uuid) + UUID.bin(task.uuid) + payload
  end

  def initialize raw
    @raw = raw
    type = raw[0..3]
    known_types = %w(DATA PING RGST RSLT)
    fail UnknownType, type unless known_types.include? type or type.empty?
  end

  def == other
    raw == other.raw
  end

  def client_uuid
    UUID[raw[16..31]]
  end

  def payload
    raw[64..-1]
  end

  def project_uuid
    UUID[raw[32..47]]
  end

  def task_uuid
    UUID[raw[48..63]]
  end

  def to_s
    raw
  end

  def type
    raw[0..3].to_sym
  end

  attr_reader :raw
  private     :raw
end end

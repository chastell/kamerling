module Kamerling class Message
  KnownTypes  = %w[DATA RGST RSLT]
  UnknownType = Class.new RuntimeError

  attr_reader :raw

  def self.[](client: req(:client), payload: req(:payload),
              project: req(:project), task: req(:task), type: req(:type))
    new "#{type}\0\0\0\0\0\0\0\0\0\0\0\0" + UUID.bin(client.uuid) +
      UUID.bin(project.uuid) + UUID.bin(task.uuid) + payload
  end

  def initialize raw
    @raw = raw
    type = raw[0..3]
    raise UnknownType, type unless KnownTypes.include? type
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

  def type
    raw[0..3].to_sym
  end
end end

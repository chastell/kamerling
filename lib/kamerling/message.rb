module Kamerling class Message
  attr_reader :raw

  def self.[] client: req(:client), payload: req(:payload), project: req(:project), task: req(:task)
    type = name.split('::').last
    raw  = type + "\0\0\0\0\0\0\0\0\0\0\0\0" + UUID.bin(client.uuid) +
      UUID.bin(project.uuid) + UUID.bin(task.uuid) + payload
    new raw
  end

  def initialize raw
    @raw = raw
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
    raw[0..3]
  end
end end

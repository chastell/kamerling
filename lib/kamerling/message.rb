module Kamerling class Message
  attr_reader :input

  def self.[] client: req(:client), data: req(:data), project: req(:project), task: req(:task)
    type  = name.split('::').last
    input = type + "\0\0\0\0\0\0\0\0\0\0\0\0" + UUID.bin(client.uuid) +
      UUID.bin(project.uuid) + UUID.bin(task.uuid) + data
    new input
  end

  def initialize input
    @input = input
  end

  def == other
    input == other.input
  end

  def client_uuid
    UUID[input[16..31]]
  end

  def data
    input[64..-1]
  end

  def project_uuid
    UUID[input[32..47]]
  end

  def task_uuid
    UUID[input[48..63]]
  end

  def type
    input[0..3]
  end
end end

require_relative 'uuid'

module Kamerling class Message
  KNOWN_TYPES = %i(DATA PING RGST RSLT)
  UnknownType = Class.new RuntimeError

  def self.parse raw
    new raw: raw
  end

  def initialize client: nil, payload: nil, project: nil, raw: nil, task: nil,
                 type: raw[0..3].to_sym
    fail UnknownType, type unless KNOWN_TYPES.include? type or type.empty?
    @raw = raw || raw_from(client, payload, project, task, type)
  end

  def client_uuid
    UUID[raw[16..31]]
  end

  def eql? other
    raw.eql? other.raw
  end

  alias_method :==, :eql?

  def payload
    raw[64..-1]
  end

  def project_uuid
    UUID[raw[32..47]]
  end

  def task_uuid
    UUID[raw[48..63]]
  end

  def to_hex
    raw.unpack('H*').first.scan(/../).join ' '
  end

  def to_s
    raw
  end

  def type
    raw[0..3].to_sym
  end

  attr_reader :raw
  protected   :raw

  private

  def raw_from client, payload, project, task, type
    "#{type}\0\0\0\0\0\0\0\0\0\0\0\0" + UUID.bin(client.uuid) +
      UUID.bin(project.uuid) + UUID.bin(task.uuid) + payload
  end
end end

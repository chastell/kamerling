module Kamerling class Result < UUIDEntity
  attribute :addr,   Addr
  attribute :client, Client
  attribute :data,   String
  attribute :task,   Task

  def to_h
    super
      .reject { |key, _| key == :addr   }.merge(addr.to_h)
      .reject { |key, _| key == :client }.merge(client_uuid: client.uuid)
      .reject { |key, _| key == :task   }.merge task_uuid:   task.uuid
  end
end end

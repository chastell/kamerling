module Kamerling class Registration < UUIDEntity
  attribute :addr,    Addr
  attribute :client,  Client
  attribute :project, Project

  def to_h
    super
      .reject { |key, _| key == :addr    }.merge(addr.to_h)
      .reject { |key, _| key == :client  }.merge(client_uuid:  client.uuid)
      .reject { |key, _| key == :project }.merge project_uuid: project.uuid
  end
end end

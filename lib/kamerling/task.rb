module Kamerling class Task < UUIDEntity
  attribute :data,    String
  attribute :done,    Boolean, default: false
  attribute :project, Project

  def to_h
    super.reject { |key, _| key == :project }.merge project_uuid: project.uuid
  end
end end

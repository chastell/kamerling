module Kamerling class Mapper
  def self.to_h object
    case object
    when Client
      object.to_h.reject { |key, _| key == :addr }.merge object.addr.to_h
    when Task
      object.to_h.reject { |key, _| key == :project }
        .merge project_uuid: object.project.uuid
    else
      object.to_h
    end
  end
end end

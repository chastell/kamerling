module Kamerling class Mapper
  def self.from_h klass, hash
    case klass.name.split('::').last
    when 'Client'
      klass.from_h hash.merge addr: Addr[hash[:host], hash[:port], hash[:prot]]
    else
      klass.from_h hash
    end
  end

  def self.to_h object
    case object
    when Client
      object.to_h.reject { |key, _| key == :addr }.merge object.addr.to_h
    when Registration
      object.to_h
        .reject { |key, _| key == :addr    }
        .merge(object.addr.to_h)
        .reject { |key, _| key == :client  }
        .merge(client_uuid:  object.client.uuid)
        .reject { |key, _| key == :project }
        .merge project_uuid: object.project.uuid
    when Result
      object.to_h
        .reject { |key, _| key == :addr    }
        .merge(object.addr.to_h)
        .reject { |key, _| key == :client  }
        .merge(client_uuid:  object.client.uuid)
        .reject { |key, _| key == :task }
        .merge task_uuid: object.task.uuid
    when Task
      object.to_h.reject { |key, _| key == :project }
        .merge project_uuid: object.project.uuid
    else
      object.to_h
    end
  end
end end

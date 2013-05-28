module Kamerling
  Registration = Struct.new :addr, :client, :project, :uuid do
    include RandomUUID

    def initialize addr: raise, client: raise, project: raise, uuid: random_uuid
      super addr, client, project, uuid
    end
  end
end

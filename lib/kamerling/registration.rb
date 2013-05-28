module Kamerling
  Registration = Struct.new :addr, :client, :project, :uuid do
    include RandomUUID

    def initialize addr: raise, client: raise, project: raise, uuid: random_uuid
      super addr, client, project, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! host: addr.host, port: addr.port
        hash.delete :addr
      end
    end
  end
end

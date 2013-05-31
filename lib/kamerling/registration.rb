module Kamerling
  Registration = Struct.new :addr, :client, :project, :uuid do
    def self.from_h hash
      hash.merge! addr:    Addr[hash[:host], hash[:port]]
      hash.merge! client:  Repos[Client][hash[:client_uuid]]
      hash.merge! project: Repos[Project][hash[:project_uuid]]
      hash.delete :host
      hash.delete :port
      hash.delete :client_uuid
      hash.delete :project_uuid
      new hash
    end

    def initialize addr: raise, client: raise, project: raise, uuid: UUID.new
      super addr, client, project, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! client_uuid: client.uuid, project_uuid: project.uuid
        hash.merge! host: addr.host, port: addr.port
        hash.delete :addr
        hash.delete :client
        hash.delete :project
      end
    end
  end
end

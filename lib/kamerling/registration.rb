module Kamerling class Registration < UUIDObject addr: nil, client: nil, project: nil
  def self.from_h hash, repos = Repos
    hash.merge! addr:    Addr[hash[:host], hash[:port]]
    hash.merge! client:  repos[Client][hash[:client_uuid]]
    hash.merge! project: repos[Project][hash[:project_uuid]]
    hash.delete :host
    hash.delete :port
    hash.delete :client_uuid
    hash.delete :project_uuid
    new hash
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
end end

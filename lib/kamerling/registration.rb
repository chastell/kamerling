module Kamerling class Registration < UUIDObject :addr, :client, :project
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
end end

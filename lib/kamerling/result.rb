module Kamerling class Result < UUIDObject :addr, :client, :data, :task
  def self.from_h hash, repos = Repos
    hash.merge! addr:   Addr[hash[:host], hash[:port]]
    hash.merge! client: repos[Client][hash[:client_uuid]]
    hash.merge! task:   repos[Task][hash[:task_uuid]]
    hash.delete :host
    hash.delete :port
    hash.delete :client_uuid
    hash.delete :task_uuid
    new hash
  end
end end

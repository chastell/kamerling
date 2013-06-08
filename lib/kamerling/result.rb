module Kamerling
  Result = Struct.new :addr, :client, :data, :task, :uuid do
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

    def initialize addr: req(:addr), client: req(:client), data: req(:data), task: req(:task), uuid: UUID.new
      super addr, client, data, task, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! client_uuid: client.uuid, task_uuid: task.uuid
        hash.merge! host: addr.host, port: addr.port
        hash.delete :addr
        hash.delete :client
        hash.delete :task
      end
    end
  end
end

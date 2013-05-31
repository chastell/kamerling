module Kamerling
  Result = Struct.new :addr, :client, :data, :task, :uuid do
    def self.from_h hash
      hash.merge! addr:   Addr[hash[:host], hash[:port]]
      hash.merge! client: Repos[Client][hash[:client_uuid]]
      hash.merge! task:   Repos[Task][hash[:task_uuid]]
      hash.delete :host
      hash.delete :port
      hash.delete :client_uuid
      hash.delete :task_uuid
      new hash
    end

    def initialize addr: raise, client: raise, data: raise, task: raise,
      uuid: UUID.new
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

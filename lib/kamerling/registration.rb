module Kamerling
  Registration = Struct.new :addr, :client, :project, :uuid do
    include RandomUUID

    def self.from_h hash
      hash.merge! addr: Addr[hash[:host], hash[:port]]
      hash.delete :host
      hash.delete :port
      new hash
    end

    def initialize addr: raise, client: raise, project: raise, uuid: random_uuid
      super addr, client, project, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! client_uuid: client.uuid, host: addr.host, port: addr.port
        hash.delete :addr
        hash.delete :client
      end
    end
  end
end

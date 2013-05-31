module Kamerling
  Result = Struct.new :addr, :client, :data, :task, :uuid do
    def initialize addr: raise, client: raise, data: raise, task: raise,
      uuid: UUID.new
      super addr, client, data, task, uuid
    end
  end
end

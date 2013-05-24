module Kamerling
  Result = Struct.new :client, :client_addr, :data, :task do
    def initialize client: raise, client_addr: raise, data: raise, task: raise
      super client, client_addr, data, task
    end
  end
end

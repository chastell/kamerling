module Kamerling
  Result = Struct.new :addr, :client, :data, :task do
    def initialize addr: raise, client: raise, data: raise, task: raise
      super addr, client, data, task
    end
  end
end

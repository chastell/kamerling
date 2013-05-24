module Kamerling
  Registration = Struct.new :client, :client_addr, :project do
    def initialize client: raise, client_addr: raise, project: raise
      super client, client_addr, project
    end
  end
end

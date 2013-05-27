module Kamerling
  Registration = Struct.new :addr, :client, :project do
    def initialize addr: raise, client: raise, project: raise
      super addr, client, project
    end
  end
end

module Kamerling
  Client = Struct.new :uuid do
    def initialize uuid: raise
      super uuid
    end
  end
end

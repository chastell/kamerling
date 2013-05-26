module Kamerling
  Project = Struct.new :name, :uuid do
    def initialize name: raise, uuid: raise
      super name, uuid
    end
  end
end

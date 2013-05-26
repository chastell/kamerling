module Kamerling
  Project = Struct.new :name, :uuid do
    class << self
      alias :from_h :new
    end

    def initialize name: raise, uuid: raise
      super name, uuid
    end
  end
end

module Kamerling
  Project = Struct.new :name, :uuid do
    class << self
      alias :from_h :new
    end

    def initialize name: req(:name), uuid: UUID.new
      super name, uuid
    end
  end
end

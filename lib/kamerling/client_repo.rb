require_relative 'mapper'

module Kamerling
  class ClientRepo
    def initialize(db)
      @db = db
    end

    def <<(client)
      warn_off { db[:clients] << Mapper.to_h(client) }
    end

    private

    private_attr_reader :db
  end
end

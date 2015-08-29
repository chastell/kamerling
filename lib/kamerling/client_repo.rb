require_relative 'mapper'

module Kamerling
  class ClientRepo
    def initialize(db)
      @clients = warn_off { db[:clients] }
    end

    def <<(client)
      warn_off { clients << Mapper.to_h(client) }
    end

    private

    private_attr_reader :clients
  end
end

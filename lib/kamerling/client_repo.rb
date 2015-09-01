require_relative 'mapper'

module Kamerling
  class ClientRepo
    def initialize(db)
      @clients = warn_off { db[:clients] }
    end

    def <<(client)
      hash = Mapper.to_h(client)
      warn_off { clients << hash }
    rescue Sequel::UniqueConstraintViolation
      warn_off { clients.where(uuid: client.uuid).update hash }
    end

    def all
      warn_off { clients.all }.map { |hash| Mapper.from_h(Client, hash) }
    end

    def fetch(uuid)
      Mapper.from_h(Client, warn_off { clients[uuid: uuid] })
    end

    private

    private_attr_reader :clients
  end
end

require_relative 'mapper'

module Kamerling
  class ClientRepo
    def initialize(db)
      @clients = db[:clients]
    end

    def <<(client)
      hash = Mapper.to_h(client)
      clients << hash
    rescue Sequel::UniqueConstraintViolation
      clients.where(uuid: client.uuid).update hash
    end

    def all
      clients.all.map { |hash| Mapper.from_h(Client, hash) }
    end

    def fetch(uuid)
      Mapper.from_h(Client, clients[uuid: uuid])
    end

    private

    private_attr_reader :clients
  end
end

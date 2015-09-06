require 'sequel'
require_relative 'client'
require_relative 'mapper'

module Kamerling
  class ClientRepo
    def initialize(db)
      @table = db[:clients]
    end

    def <<(client)
      hash = Mapper.to_h(client)
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(uuid: client.uuid).update hash
    end

    def all
      table.all.map { |hash| Mapper.from_h(Client, hash) }
    end

    def fetch(uuid)
      Mapper.from_h(Client, table[uuid: uuid])
    end

    private

    private_attr_reader :table
  end
end

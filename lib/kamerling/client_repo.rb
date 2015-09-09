require 'sequel'
require_relative 'client'
require_relative 'mapper'
require_relative 'new_repo'
require_relative 'settings'

module Kamerling
  class ClientRepo < NewRepo
    def initialize(db = Settings.new.client_db)
      @klass = Client
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

    private

    private_attr_reader :table
  end
end

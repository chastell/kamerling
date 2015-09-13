require_relative 'client'
require_relative 'mapper'
require_relative 'new_repo'
require_relative 'settings'

module Kamerling
  class ClientRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Client
      @table = db[:clients]
    end

    def all
      table.all.map { |hash| Mapper.from_h(Client, hash) }
    end
  end
end

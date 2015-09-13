require 'sequel'
require_relative 'mapper'

module Kamerling
  class NewRepo
    def <<(object)
      hash = Mapper.to_h(object)
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(uuid: object.uuid).update hash
    end

    def fetch(uuid)
      Mapper.from_h(klass, table[uuid: uuid])
    end

    private

    private_attr_reader :klass, :table
  end
end

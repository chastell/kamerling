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
      hash = table[uuid: uuid]
      hash ? Mapper.from_h(klass, hash) : yield
    end

    private

    private_attr_reader :klass, :table
  end
end

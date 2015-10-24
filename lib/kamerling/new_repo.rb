require 'sequel'

module Kamerling
  class NewRepo
    def <<(object)
      hash = object.new_to_h
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(uuid: object.uuid).update hash
    end

    def fetch(uuid)
      hash = table[uuid: uuid]
      hash ? klass.new(hash) : yield
    end

    private

    private_attr_reader :klass, :table
  end
end

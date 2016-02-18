# frozen_string_literal: true

require 'sequel'

module Kamerling
  class NewRepo
    NotFound = Class.new(RuntimeError)

    def <<(object)
      hash = object.new_to_h
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(uuid: object.uuid).update hash
    end

    def fetch(uuid)
      case
      when hash = table[uuid: uuid] then klass.new(hash)
      when block_given?             then yield
      else raise NotFound
      end
    end

    private

    private_attr_reader :klass, :table
  end
end

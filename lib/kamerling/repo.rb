# frozen_string_literal: true

require 'sequel'

module Kamerling
  class Repo
    NotFound = Class.new(RuntimeError)

    def initialize(db = Sequel.sqlite)
      @db = db
    end

    def <<(object)
      hash = object.to_h
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(id: object.id).update hash
    end

    def all
      table.all.map(&klass.method(:new))
    end

    def fetch(id)
      case
      when hash = table[id: id] then klass.new(hash)
      when block_given?         then yield
      else raise NotFound
      end
    end

    private

    attr_reader :db
  end
end

# frozen_string_literal: true

require 'sequel'
require_relative 'settings'

module Kamerling
  class Repo
    NotFound = Class.new(RuntimeError)

    def initialize(db = Settings.new.db_conn)
      @db = db
    end

    def <<(object)
      hash = object.to_h
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(uuid: object.uuid).update hash
    end

    def all
      table.all.map(&klass.method(:new))
    end

    def fetch(uuid)
      case
      when hash = table[uuid: uuid] then klass.new(hash)
      when block_given?             then yield
      else raise NotFound
      end
    end

    private

    attr_reader :db, :klass, :table
  end
end

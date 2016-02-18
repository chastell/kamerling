# frozen_string_literal: true

require 'sequel'
require_relative 'mapper'

module Kamerling
  class Repo
    NotFound = Class.new(RuntimeError)

    def initialize(klass, source, mapper: Mapper)
      @klass  = klass
      @mapper = mapper
      @source = source
    end

    def <<(object)
      hash = mapper.to_h(object)
      source << hash
    rescue Sequel::UniqueConstraintViolation
      source.where(uuid: object.uuid).update hash
    end

    def [](uuid)
      hash = source[uuid: uuid]
      raise NotFound, "#{klass} with UUID #{uuid}" unless hash
      mapper.from_h(klass, hash)
    end

    def all
      source.all.map { |hash| mapper.from_h(klass, hash) }
    end

    def related_to(object)
      key = "#{object.class.name.split('::').last.downcase}_uuid".to_sym
      source.where(key => object.uuid).map { |hash| mapper.from_h(klass, hash) }
    end

    private

    attr_reader :klass, :mapper, :source
  end
end

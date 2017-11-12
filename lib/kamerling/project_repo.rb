require_relative 'project'
require_relative 'repo'

module Kamerling
  class ProjectRepo < Repo
    def <<(object)
      hash = object.to_h
      table << hash
    rescue Sequel::UniqueConstraintViolation
      table.where(id: object.id).update hash
    end

    private

    def klass
      Project
    end

    def table
      db[:projects]
    end
  end
end

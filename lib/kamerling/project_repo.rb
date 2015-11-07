require_relative 'project'
require_relative 'new_repo'

module Kamerling
  class ProjectRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Project
      @table = db[:projects]
    end

    def all
      table.all.map(&Project.method(:new))
    end

    private

    private_attr_reader :table
  end
end

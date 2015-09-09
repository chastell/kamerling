require_relative 'project'
require_relative 'new_repo'

module Kamerling
  class ProjectRepo < NewRepo
    def initialize(db)
      @klass = Project
      @table = db[:projects]
    end

    private

    private_attr_reader :table
  end
end

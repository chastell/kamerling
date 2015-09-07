require_relative 'project'
require_relative 'mapper'

module Kamerling
  class ProjectRepo
    def initialize(db)
      @table = db[:projects]
    end

    def fetch(uuid)
      Mapper.from_h(Project, table[uuid: uuid])
    end

    private

    private_attr_reader :table
  end
end

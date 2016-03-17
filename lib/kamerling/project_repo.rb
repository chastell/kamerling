# frozen_string_literal: true

require_relative 'client'
require_relative 'new_repo'
require_relative 'project'
require_relative 'task'

module Kamerling
  class ProjectRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Project
      @table = db[:projects]
    end
  end
end

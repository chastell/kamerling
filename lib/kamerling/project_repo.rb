# frozen_string_literal: true

require_relative 'client'
require_relative 'project'
require_relative 'repo'
require_relative 'task'

module Kamerling
  class ProjectRepo < Repo
    def initialize(db = Settings.new.db_conn)
      @klass = Project
      @table = db[:projects]
    end
  end
end

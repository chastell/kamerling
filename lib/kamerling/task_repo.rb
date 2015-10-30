require_relative 'new_repo'

module Kamerling
  class TaskRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Task
      @table = db[:tasks]
    end
  end
end

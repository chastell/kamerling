# frozen_string_literal: true

require_relative 'new_repo'

module Kamerling
  class ResultRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Result
      @table = db[:results]
    end
  end
end

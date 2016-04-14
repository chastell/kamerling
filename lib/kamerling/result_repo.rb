# frozen_string_literal: true

require_relative 'repo'
require_relative 'result'
require_relative 'settings'

module Kamerling
  class ResultRepo < Repo
    def initialize(db = Settings.new.db_conn)
      @klass = Result
      @table = db[:results]
    end
  end
end

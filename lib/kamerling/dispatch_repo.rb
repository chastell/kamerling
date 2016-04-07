# frozen_string_literal: true

require_relative 'dispatch'
require_relative 'new_repo'
require_relative 'settings'

module Kamerling
  class DispatchRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @klass = Dispatch
      @table = db[:dispatches]
    end
  end
end

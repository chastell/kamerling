# frozen_string_literal: true

require_relative 'dispatch'
require_relative 'repo'
require_relative 'settings'

module Kamerling
  class DispatchRepo < Repo
    def initialize(db = Settings.new.db_conn)
      @klass = Dispatch
      @table = db[:dispatches]
    end
  end
end

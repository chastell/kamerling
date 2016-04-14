# frozen_string_literal: true

require_relative 'registration'
require_relative 'repo'
require_relative 'settings'

module Kamerling
  class RegistrationRepo < Repo
    def initialize(db = Settings.new.db_conn)
      @klass = Registration
      @table = db[:registrations]
    end
  end
end

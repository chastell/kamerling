require_relative 'new_repo'

module Kamerling
  class RegistrationRepo < NewRepo
    def initialize(db = Settings.new.db_conn)
      @table = db[:registrations]
    end

    private

    private_attr_reader :table
  end
end

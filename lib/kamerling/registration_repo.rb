# frozen_string_literal: true

require_relative 'registration'
require_relative 'repo'

module Kamerling
  class RegistrationRepo < Repo
    private

    def klass
      Registration
    end

    def table
      db[:registrations]
    end
  end
end

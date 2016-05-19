# frozen_string_literal: true

require_relative 'dispatch'
require_relative 'repo'

module Kamerling
  class DispatchRepo < Repo
    private

    def klass
      Dispatch
    end

    def table
      db[:dispatches]
    end
  end
end

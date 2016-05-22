# frozen_string_literal: true

require_relative 'repo'
require_relative 'result'

module Kamerling
  class ResultRepo < Repo
    private

    def klass
      Result
    end

    def table
      db[:results]
    end
  end
end

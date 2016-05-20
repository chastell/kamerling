# frozen_string_literal: true

require_relative 'project'
require_relative 'repo'

module Kamerling
  class ProjectRepo < Repo
    private

    def klass
      Project
    end

    def table
      db[:projects]
    end
  end
end

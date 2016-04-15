# frozen_string_literal: true

require_relative 'entity'

module Kamerling
  class Project < Entity
    attrs name: String
  end
end

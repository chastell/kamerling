# frozen_string_literal: true

require_relative 'entity'

module Kamerling
  class Project < Entity
    attrs name: String

    alias new_to_h to_h
  end
end

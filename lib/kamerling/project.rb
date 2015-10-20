require_relative 'entity'

module Kamerling
  class Project < Entity
    attrs name: String

    alias_method :new_to_h, :to_h
  end
end

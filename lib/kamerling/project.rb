require_relative 'entity'

module Kamerling
  class Project < Entity
    attrs clients: Array, name: String

    def new_to_h
      to_h.reject { |key, _| key == :clients }
    end
  end
end
